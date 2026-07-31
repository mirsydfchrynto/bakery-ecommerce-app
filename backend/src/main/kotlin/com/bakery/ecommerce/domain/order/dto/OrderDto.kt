package com.bakery.ecommerce.domain.order.dto

import jakarta.validation.Valid
import jakarta.validation.constraints.Min
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotEmpty
import jakarta.validation.constraints.NotNull
import java.math.BigDecimal
import java.util.UUID
import java.time.OffsetDateTime

data class CheckoutRequestDto(
    @field:NotEmpty(message = "Cart cannot be empty")
    val items: List<@Valid CheckoutItemDto>,

    @field:NotNull(message = "Shipping address is required")
    val shippingAddress: @Valid ShippingAddressDto
)

data class CheckoutItemDto(
    @field:NotNull(message = "Product ID is required")
    val productId: UUID,

    @field:Min(value = 1, message = "Quantity must be at least 1")
    val quantity: Int
)

data class ShippingAddressDto(
    @field:NotBlank(message = "Recipient name is required")
    val recipientName: String,

    @field:NotBlank(message = "Phone number is required")
    val phoneNumber: String,

    @field:NotBlank(message = "Full address is required")
    val fullAddress: String,

    @field:NotNull(message = "Latitude is required")
    val latitude: BigDecimal,

    @field:NotNull(message = "Longitude is required")
    val longitude: BigDecimal
)

data class OrderItemResponseDto(
    val productId: UUID,
    val productName: String,
    val quantity: Int,
    val priceAtPurchase: BigDecimal
)

data class OrderResponseDto(
    val id: UUID,
    val totalAmount: BigDecimal,
    val status: String,
    val orderedAt: OffsetDateTime,
    val customerName: String? = null,
    val customerPhone: String? = null,
    val rejectionReason: String? = null,
    val items: List<OrderItemResponseDto> = emptyList()
)
