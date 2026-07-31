package com.bakery.ecommerce.domain.order.service

import com.bakery.ecommerce.domain.catalog.ProductRepository
import com.bakery.ecommerce.domain.catalog.ProductStatus
import com.bakery.ecommerce.domain.iam.UserRepository
import com.bakery.ecommerce.domain.inventory.InventoryRepository
import com.bakery.ecommerce.domain.order.Order
import com.bakery.ecommerce.domain.order.OrderAddressRepository
import com.bakery.ecommerce.domain.order.OrderItem
import com.bakery.ecommerce.domain.order.OrderItemRepository
import com.bakery.ecommerce.domain.order.OrderRepository
import com.bakery.ecommerce.domain.order.OrderStatus
import com.bakery.ecommerce.domain.order.dto.CheckoutRequestDto
import com.bakery.ecommerce.domain.order.dto.OrderResponseDto
import com.bakery.ecommerce.domain.order.mapper.OrderMapper
import com.bakery.ecommerce.exception.BusinessException
import com.bakery.ecommerce.exception.ResourceNotFoundException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.util.UUID

@Service
class OrderService(
    private val orderRepository: OrderRepository,
    private val orderItemRepository: OrderItemRepository,
    private val orderAddressRepository: OrderAddressRepository,
    private val productRepository: ProductRepository,
    private val inventoryRepository: InventoryRepository,
    private val userRepository: UserRepository,
    private val orderMapper: OrderMapper
) {

    @Transactional
    fun checkout(customerId: UUID, request: CheckoutRequestDto): OrderResponseDto {
        val customer = userRepository.findById(customerId)
            .orElseThrow { ResourceNotFoundException("USER-001", "Customer not found") }

        var totalAmount = BigDecimal.ZERO
        val orderItems = mutableListOf<OrderItem>()

        // Create base order (will save at the end, but need instance for relation)
        val order = Order().apply {
            this.customer = customer
            this.status = OrderStatus.WAITING_PAYMENT
        }
        val savedOrder = orderRepository.save(order)

        // Sort items by product ID to prevent deadlocks when acquiring PESSIMISTIC_WRITE locks
        val sortedItems = request.items.sortedBy { it.productId }

        // Process items
        for (itemDto in sortedItems) {
            val product = productRepository.findById(itemDto.productId)
                .orElseThrow { ResourceNotFoundException("ORDER-002", "Product not found: ${itemDto.productId}") }

            if (product.status != ProductStatus.ACTIVE) {
                throw BusinessException("ORDER-002", "Product is not active: ${product.name}")
            }

            // PESSIMISTIC_WRITE lock on inventory
            val inventory = inventoryRepository.findByProductIdForUpdate(product.id!!)
                ?: throw BusinessException("ORDER-003", "Inventory record missing for product: ${product.name}")

            if (inventory.getAvailableStock() < itemDto.quantity) {
                throw BusinessException("ORDER-003", "Insufficient stock for product: ${product.name}")
            }

            // Reserve stock
            inventory.reservedStock += itemDto.quantity
            inventoryRepository.save(inventory)

            val orderItem = OrderItem().apply {
                this.order = savedOrder
                this.product = product
                this.quantity = itemDto.quantity
                this.priceAtPurchase = product.price
                this.productName = product.name
            }
            orderItems.add(orderItem)

            val subtotal = product.price.multiply(BigDecimal(itemDto.quantity))
            totalAmount = totalAmount.add(subtotal)
        }

        // Add flat delivery fee (matches frontend CartScreen)
        val deliveryFee = BigDecimal("15000.00")
        totalAmount = totalAmount.add(deliveryFee)

        orderItemRepository.saveAll(orderItems)

        // Update total amount on the order
        savedOrder.totalAmount = totalAmount
        orderRepository.save(savedOrder) // Update

        // Save Snapshot Address
        val address = orderMapper.toAddressEntity(request.shippingAddress, savedOrder)
        orderAddressRepository.save(address)

        return orderMapper.toResponseDto(savedOrder)
    }

    @Transactional(readOnly = true)
    fun getMyOrders(customerId: UUID, pageable: org.springframework.data.domain.Pageable): org.springframework.data.domain.Page<OrderResponseDto> {
        val orders = orderRepository.findByCustomerId(customerId, pageable)
        return orders.map { orderMapper.toResponseDto(it) }
    }

    @Transactional(readOnly = true)
    fun getAllOrders(status: OrderStatus?, pageable: org.springframework.data.domain.Pageable): org.springframework.data.domain.Page<OrderResponseDto> {
        val orders = if (status != null) {
            orderRepository.findByStatus(status, pageable)
        } else {
            orderRepository.findAll(pageable)
        }
        return orders.map { orderMapper.toResponseDto(it) }
    }

    @Transactional
    fun updateOrderStatus(orderId: UUID, status: OrderStatus): OrderResponseDto {
        val order = orderRepository.findById(orderId)
            .orElseThrow { ResourceNotFoundException("ORDER-004", "Order not found") }

        // Handle inventory based on status transitions
        if (order.status != status) {
            when (status) {
                OrderStatus.COMPLETED -> {
                    // Finalize sale: decrease both stock and reserved stock
                    // Sort by product ID to prevent deadlocks
                    val sortedItems = order.items.sortedBy { it.product?.id }
                    sortedItems.forEach { item ->
                        val inventory = inventoryRepository.findByProductIdForUpdate(item.product?.id!!)
                        if (inventory != null) {
                            inventory.stock -= item.quantity
                            inventory.reservedStock -= item.quantity
                            inventoryRepository.save(inventory)
                        }
                    }
                }
                OrderStatus.CANCELLED, OrderStatus.PAYMENT_REJECTED, OrderStatus.EXPIRED -> {
                    // Release reserved stock back to available pool
                    // Only release if the previous status was actually reserving them
                    if (order.status != OrderStatus.CANCELLED && 
                        order.status != OrderStatus.PAYMENT_REJECTED && 
                        order.status != OrderStatus.EXPIRED &&
                        order.status != OrderStatus.COMPLETED) {
                        
                        // Sort by product ID to prevent deadlocks
                        val sortedItems = order.items.sortedBy { it.product?.id }
                        sortedItems.forEach { item ->
                            val inventory = inventoryRepository.findByProductIdForUpdate(item.product?.id!!)
                            if (inventory != null) {
                                inventory.reservedStock -= item.quantity
                                inventoryRepository.save(inventory)
                            }
                        }
                    }
                }
                else -> { /* Other statuses don't affect inventory directly */ }
            }
        }
        
        order.status = status
        val updatedOrder = orderRepository.save(order)
        return orderMapper.toResponseDto(updatedOrder)
    }

    @Transactional
    fun cancelOrder(customerId: UUID, orderId: UUID): OrderResponseDto {
        val order = orderRepository.findById(orderId)
            .orElseThrow { ResourceNotFoundException("ORDER-004", "Order not found") }

        if (order.customer?.id != customerId) {
            throw BusinessException("ORDER-005", "Not authorized to cancel this order")
        }

        if (order.status != OrderStatus.WAITING_PAYMENT && order.status != OrderStatus.PENDING) {
            throw BusinessException("ORDER-006", "Only pending or waiting payment orders can be cancelled by customer")
        }

        // Release reserved stock back to available pool
        val sortedItems = order.items.sortedBy { it.product?.id }
        sortedItems.forEach { item ->
            val inventory = inventoryRepository.findByProductIdForUpdate(item.product?.id!!)
            if (inventory != null) {
                inventory.reservedStock -= item.quantity
                inventoryRepository.save(inventory)
            }
        }

        order.status = OrderStatus.CANCELLED
        val updatedOrder = orderRepository.save(order)
        return orderMapper.toResponseDto(updatedOrder)
    }
}
