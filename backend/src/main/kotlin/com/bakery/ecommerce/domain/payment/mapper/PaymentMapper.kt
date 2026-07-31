package com.bakery.ecommerce.domain.payment.mapper

import com.bakery.ecommerce.domain.payment.Payment
import com.bakery.ecommerce.domain.payment.dto.PaymentResponseDto
import org.springframework.stereotype.Component

@Component
class PaymentMapper {
    fun toResponseDto(payment: Payment): PaymentResponseDto {
        return PaymentResponseDto(
            id = payment.id!!,
            orderId = payment.order!!.id!!,
            paymentStatus = payment.paymentStatus.name,
            paymentMethod = payment.paymentMethod,
            transferAmount = payment.transferAmount
        )
    }
}
