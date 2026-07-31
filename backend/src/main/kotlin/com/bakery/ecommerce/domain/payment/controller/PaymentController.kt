package com.bakery.ecommerce.domain.payment.controller

import com.bakery.ecommerce.exception.BaseResponse
import com.bakery.ecommerce.domain.payment.Payment
import com.bakery.ecommerce.domain.payment.PaymentRepository
import com.bakery.ecommerce.domain.payment.PaymentStatus
import com.bakery.ecommerce.domain.order.OrderRepository
import com.bakery.ecommerce.domain.order.OrderStatus
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.Parameter
import io.swagger.v3.oas.annotations.media.Content
import io.swagger.v3.oas.annotations.security.SecurityRequirement
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile
import java.math.BigDecimal
import java.util.UUID
import com.bakery.ecommerce.domain.storage.service.StorageService
import com.fasterxml.jackson.databind.ObjectMapper

@RestController
@RequestMapping("/api/v1/payments")
@Tag(name = "Payment", description = "Endpoints for Customer Payments")
@SecurityRequirement(name = "bearerAuth")
class PaymentController(
    private val paymentRepository: PaymentRepository,
    private val orderRepository: OrderRepository,
    private val storageService: StorageService
) {
    private val mapper = ObjectMapper()

    @PostMapping(value = ["/{orderId}/upload"], consumes = [MediaType.MULTIPART_FORM_DATA_VALUE])
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Upload payment proof for an order (Max 5 images)")
    fun uploadPaymentProof(
        @AuthenticationPrincipal userDetails: UserDetails,
        @PathVariable("orderId") orderId: UUID,
        @Parameter(description = "Payment method e.g. BCA Transfer") @RequestParam("paymentMethod") paymentMethod: String,
        @Parameter(description = "Bank name") @RequestParam("bankName") bankName: String,
        @Parameter(description = "Account name") @RequestParam("accountName") accountName: String,
        @Parameter(description = "Transfer amount") @RequestParam("transferAmount") transferAmount: BigDecimal,
        @Parameter(
            description = "Payment proof images (JPG/PNG)",
            content = [Content(mediaType = MediaType.MULTIPART_FORM_DATA_VALUE)]
        ) @RequestPart("files") files: List<MultipartFile>
    ): ResponseEntity<BaseResponse<Map<String, String>>> {
        val customerId = UUID.fromString(userDetails.username)
        val order = orderRepository.findById(orderId).orElseThrow { Exception("Order not found") }

        if (order.customer?.id != customerId) {
            throw Exception("Not authorized to pay for this order")
        }

        if (files.isEmpty() || files.size > 5) {
            throw Exception("You must upload between 1 and 5 payment proof images.")
        }

        val savedUrls = storageService.uploadFiles(files)
        val paymentUrlsJson = mapper.writeValueAsString(savedUrls)

        val payment = paymentRepository.findByOrderId(orderId) ?: Payment().apply { this.order = order }
        payment.paymentMethod = paymentMethod
        payment.bankName = bankName
        payment.accountName = accountName
        payment.transferAmount = transferAmount
        payment.paymentProofUrls = paymentUrlsJson
        payment.paymentStatus = PaymentStatus.VERIFYING
        paymentRepository.save(payment)

        order.status = OrderStatus.VERIFYING_PAYMENT
        orderRepository.save(order)

        return ResponseEntity.ok(
            BaseResponse.success(
                mapOf("status" to "VERIFYING_PAYMENT", "urls" to paymentUrlsJson),
                "Payment proof uploaded successfully. Waiting for Admin verification."
            )
        )
    }

    @GetMapping("/admin/{orderId}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get payment details for an order (Admin only)")
    fun getPaymentDetailsForAdmin(
        @PathVariable("orderId") orderId: UUID
    ): ResponseEntity<BaseResponse<Payment>> {
        val payment = paymentRepository.findByOrderId(orderId) 
            ?: throw Exception("Payment details not found for this order")
        return ResponseEntity.ok(
            BaseResponse.success(payment, "Payment details fetched successfully")
        )
    }

    @PutMapping("/admin/{orderId}/reject")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Reject payment for an order (Admin only)")
    fun rejectPayment(
        @AuthenticationPrincipal userDetails: UserDetails,
        @PathVariable("orderId") orderId: UUID,
        @RequestParam("reason") reason: String
    ): ResponseEntity<BaseResponse<Payment>> {
        val payment = paymentRepository.findByOrderId(orderId)
            ?: throw Exception("Payment not found for this order")

        val order = orderRepository.findById(orderId).orElseThrow { Exception("Order not found") }

        payment.paymentStatus = PaymentStatus.REJECTED
        payment.rejectionReason = reason
        paymentRepository.save(payment)

        order.status = OrderStatus.PAYMENT_REJECTED
        orderRepository.save(order)

        return ResponseEntity.ok(
            BaseResponse.success(payment, "Payment rejected successfully")
        )
    }

    @PutMapping("/admin/{orderId}/accept")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Accept payment for an order (Admin only)")
    fun acceptPayment(
        @AuthenticationPrincipal userDetails: UserDetails,
        @PathVariable("orderId") orderId: UUID
    ): ResponseEntity<BaseResponse<Payment>> {
        val payment = paymentRepository.findByOrderId(orderId)
            ?: throw Exception("Payment not found for this order")

        val order = orderRepository.findById(orderId).orElseThrow { Exception("Order not found") }

        payment.paymentStatus = PaymentStatus.APPROVED
        payment.rejectionReason = null
        paymentRepository.save(payment)

        order.status = OrderStatus.PROCESSING
        orderRepository.save(order)

        return ResponseEntity.ok(
            BaseResponse.success(payment, "Payment accepted successfully. Order is now PROCESSING.")
        )
    }
}

