package com.bakery.ecommerce.domain.admin.controller

import com.bakery.ecommerce.domain.payment.dto.PaymentResponseDto
import com.bakery.ecommerce.domain.payment.dto.RejectPaymentRequestDto
import com.bakery.ecommerce.domain.payment.service.AdminPaymentService
import com.bakery.ecommerce.exception.BaseResponse
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.security.SecurityRequirement
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/api/v1/admin/payments")
@Tag(name = "Admin Payments", description = "Endpoints for Admin Payment Verifications")
@SecurityRequirement(name = "bearerAuth")
class AdminPaymentController(
    private val adminPaymentService: AdminPaymentService
) {

    @PostMapping("/{id}/approve")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Approve a payment and deduct physical stock")
    fun approvePayment(
        @AuthenticationPrincipal userDetails: UserDetails,
        @PathVariable("id") paymentId: UUID
    ): ResponseEntity<BaseResponse<PaymentResponseDto>> {
        val adminId = UUID.fromString(userDetails.username)
        val response = adminPaymentService.approvePayment(paymentId, adminId)
        
        return ResponseEntity.ok(
            BaseResponse.success(response, "Payment approved successfully")
        )
    }

    @PostMapping("/{id}/reject")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Reject a payment and rollback reserved stock")
    fun rejectPayment(
        @AuthenticationPrincipal userDetails: UserDetails,
        @PathVariable("id") paymentId: UUID,
        @Valid @RequestBody request: RejectPaymentRequestDto
    ): ResponseEntity<BaseResponse<PaymentResponseDto>> {
        val adminId = UUID.fromString(userDetails.username)
        val response = adminPaymentService.rejectPayment(paymentId, adminId, request)
        
        return ResponseEntity.ok(
            BaseResponse.success(response, "Payment rejected successfully")
        )
    }
}
