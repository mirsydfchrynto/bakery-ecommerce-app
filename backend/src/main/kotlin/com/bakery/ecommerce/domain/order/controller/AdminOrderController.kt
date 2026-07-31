package com.bakery.ecommerce.domain.order.controller

import com.bakery.ecommerce.domain.order.OrderStatus
import com.bakery.ecommerce.domain.order.dto.OrderResponseDto
import com.bakery.ecommerce.domain.order.service.OrderService
import com.bakery.ecommerce.domain.payment.PaymentRepository
import com.bakery.ecommerce.exception.BaseResponse
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.security.SecurityRequirement
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/api/v1/admin/orders")
@Tag(name = "Admin Order", description = "Endpoints for Admin to manage orders")
@SecurityRequirement(name = "bearerAuth")
class AdminOrderController(
    private val orderService: OrderService,
    private val paymentRepository: PaymentRepository
) {

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all orders (Admin only)")
    fun getAllOrders(
        @RequestParam(required = false) status: OrderStatus?,
        @org.springdoc.core.annotations.ParameterObject @org.springframework.data.web.PageableDefault(size = 10, sort = ["orderedAt"], direction = org.springframework.data.domain.Sort.Direction.DESC) pageable: org.springframework.data.domain.Pageable
    ): ResponseEntity<BaseResponse<org.springframework.data.domain.Page<OrderResponseDto>>> {
        val response = orderService.getAllOrders(status, pageable)
        return ResponseEntity.ok(
            BaseResponse.success(response, "All orders fetched successfully")
        )
    }

    @PatchMapping("/{orderId}/status")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Update order status (Admin only)")
    fun updateOrderStatus(
        @PathVariable orderId: UUID,
        @RequestParam status: OrderStatus
    ): ResponseEntity<BaseResponse<OrderResponseDto>> {
        val response = orderService.updateOrderStatus(orderId, status)
        return ResponseEntity.ok(
            BaseResponse.success(response, "Order status updated successfully")
        )
    }

    @GetMapping("/{orderId}/payment")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get payment details for an order (Admin only)")
    fun getOrderPayment(@PathVariable orderId: UUID): ResponseEntity<BaseResponse<Map<String, Any>>> {
        val payment = paymentRepository.findByOrderId(orderId)
            ?: throw Exception("Payment not found for order")
        return ResponseEntity.ok(
            BaseResponse.success(
                mapOf(
                    "paymentProofUrls" to payment.paymentProofUrls,
                    "bankName" to payment.bankName,
                    "accountName" to payment.accountName,
                    "transferAmount" to payment.transferAmount
                ),
                "Payment fetched successfully"
            )
        )
    }
}
