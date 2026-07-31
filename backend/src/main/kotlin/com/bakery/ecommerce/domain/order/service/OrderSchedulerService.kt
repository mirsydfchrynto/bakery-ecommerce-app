package com.bakery.ecommerce.domain.order.service

import com.bakery.ecommerce.domain.order.OrderRepository
import com.bakery.ecommerce.domain.order.OrderStatus
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.OffsetDateTime

@Service
class OrderSchedulerService(
    private val orderRepository: OrderRepository,
    private val orderService: OrderService
) {

    // Runs every 15 minutes
    @Scheduled(fixedRate = 900000)
    fun cancelExpiredOrders() {
        // Find orders that are WAITING_PAYMENT and older than 1 hour
        val oneHourAgo = OffsetDateTime.now().minusHours(1)
        val expiredOrders = orderRepository.findByStatusAndCreatedAtBefore(OrderStatus.WAITING_PAYMENT, oneHourAgo)
        
        var count = 0
        for (order in expiredOrders) {
            try {
                // We use updateOrderStatus because it already handles releasing the pessimistic lock on inventory correctly
                orderService.updateOrderStatus(order.id!!, OrderStatus.EXPIRED)
                count++
            } catch (e: Exception) {
                // Log and continue if one fails
                println("Failed to expire order ${order.id}: ${e.message}")
            }
        }
        
        if (count > 0) {
            println("Auto-expired $count orders that were waiting for payment.")
        }
    }
}
