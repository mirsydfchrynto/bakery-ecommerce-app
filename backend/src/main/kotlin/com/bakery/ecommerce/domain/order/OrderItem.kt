package com.bakery.ecommerce.domain.order

import com.bakery.ecommerce.common.BaseEntity
import com.bakery.ecommerce.common.BaseRepository
import com.bakery.ecommerce.domain.catalog.Product
import jakarta.persistence.*
import org.springframework.stereotype.Repository
import java.math.BigDecimal

@Entity
@Table(name = "order_items")
class OrderItem : BaseEntity() {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false)
    var order: Order? = null

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    var product: Product? = null

    @Column(name = "quantity", nullable = false)
    var quantity: Int = 0

    @Column(name = "price_at_purchase", nullable = false, precision = 12, scale = 2)
    var priceAtPurchase: BigDecimal = BigDecimal.ZERO

    @Column(name = "product_name", nullable = false, length = 100)
    var productName: String = ""
}

@Repository
interface OrderItemRepository : BaseRepository<OrderItem> {
    fun findByOrderId(orderId: java.util.UUID): List<OrderItem>
}
