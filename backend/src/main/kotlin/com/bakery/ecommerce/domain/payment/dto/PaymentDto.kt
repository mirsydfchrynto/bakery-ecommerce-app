package com.bakery.ecommerce.domain.payment.dto

import jakarta.validation.constraints.NotBlank
import java.util.UUID

data class RejectPaymentRequestDto(
    @field:NotBlank(message = "Rejection reason is required")
    val reason: String
)

data class PaymentResponseDto(
    val id: UUID,
    val orderId: UUID,
    val paymentStatus: String,
    val paymentMethod: String,
    val transferAmount: java.math.BigDecimal
)
