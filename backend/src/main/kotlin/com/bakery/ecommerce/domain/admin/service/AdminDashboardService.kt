package com.bakery.ecommerce.domain.admin.service

import com.bakery.ecommerce.domain.order.OrderRepository
import com.bakery.ecommerce.domain.order.OrderStatus
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal

@Service
class AdminDashboardService(
    private val orderRepository: OrderRepository
) {

    @Transactional(readOnly = true)
    fun getDashboardAnalytics(): Map<String, Any> {
        val totalOrders = orderRepository.count()
        val totalRevenue = orderRepository.sumTotalAmountByStatusIn(listOf(OrderStatus.COMPLETED, OrderStatus.PROCESSING))
        
        val statusCounts = orderRepository.countOrdersByStatus()
        val ordersByStatus = statusCounts.associate { 
            (it[0] as OrderStatus).name to (it[1] as Number).toInt() 
        }

        val topProductsRaw = orderRepository.findTopSellingProducts()
        val topProducts = topProductsRaw.map {
            mapOf("productName" to (it[0] as String), "quantitySold" to (it[1] as Number).toInt())
        }

        return mapOf(
            "totalRevenue" to totalRevenue,
            "totalOrders" to totalOrders,
            "ordersByStatus" to ordersByStatus,
            "topProducts" to topProducts
        )
    }
}
