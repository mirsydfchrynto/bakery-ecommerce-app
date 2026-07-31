package com.bakery.ecommerce.domain.order.mapper

import com.bakery.ecommerce.domain.order.Order
import com.bakery.ecommerce.domain.order.OrderAddress
import com.bakery.ecommerce.domain.order.dto.OrderResponseDto
import com.bakery.ecommerce.domain.order.dto.ShippingAddressDto
import com.bakery.ecommerce.domain.order.dto.OrderItemResponseDto
import com.bakery.ecommerce.domain.order.OrderAddressRepository
import com.bakery.ecommerce.domain.payment.PaymentRepository
import org.springframework.stereotype.Component

@Component
class OrderMapper {
    fun toResponseDto(order: Order): OrderResponseDto {
        val address = order.address
        val payment = order.payment
        
        return OrderResponseDto(
            id = order.id!!,
            totalAmount = order.totalAmount,
            status = order.status.name,
            orderedAt = order.orderedAt,
            customerName = address?.recipientName ?: order.customer?.username,
            customerPhone = address?.phoneNumber,
            rejectionReason = payment?.rejectionReason,
            items = order.items.map { 
                OrderItemResponseDto(
                    productId = it.product?.id ?: java.util.UUID.randomUUID(), // Fallback if product is hard deleted
                    productName = it.productName,
                    quantity = it.quantity,
                    priceAtPurchase = it.priceAtPurchase
                )
            }
        )
    }

    fun toAddressEntity(dto: ShippingAddressDto, order: Order): OrderAddress {
        return OrderAddress().apply {
            this.order = order
            this.recipientName = dto.recipientName
            this.phoneNumber = dto.phoneNumber
            this.fullAddress = dto.fullAddress
            this.latitude = dto.latitude
            this.longitude = dto.longitude
        }
    }
}
