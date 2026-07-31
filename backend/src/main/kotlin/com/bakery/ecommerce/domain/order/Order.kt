package com.bakery.ecommerce.domain.order

import com.bakery.ecommerce.common.BaseEntity
import com.bakery.ecommerce.common.BaseRepository
import com.bakery.ecommerce.domain.iam.User
import jakarta.persistence.*
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository
import java.math.BigDecimal
import java.time.OffsetDateTime
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.EntityGraph

enum class OrderStatus {
    DRAFT, PENDING, WAITING_PAYMENT, VERIFYING_PAYMENT, PROCESSING, COMPLETED, PAYMENT_REJECTED, CANCELLED, EXPIRED
}

@Entity
@Table(name = "orders")
class Order : BaseEntity() {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    var customer: User? = null

    @Column(name = "total_amount", nullable = false, precision = 12, scale = 2)
    var totalAmount: BigDecimal = BigDecimal.ZERO

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 30)
    var status: OrderStatus = OrderStatus.PENDING

    @Column(name = "ordered_at", nullable = false)
    var orderedAt: OffsetDateTime = OffsetDateTime.now()

    @OneToMany(mappedBy = "order", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    var items: MutableList<OrderItem> = mutableListOf()

    @OneToOne(mappedBy = "order", fetch = FetchType.LAZY)
    var address: OrderAddress? = null

    @OneToOne(mappedBy = "order", fetch = FetchType.LAZY)
    var payment: com.bakery.ecommerce.domain.payment.Payment? = null
}

@Repository
interface OrderRepository : BaseRepository<Order> {
    @EntityGraph(attributePaths = ["customer", "address", "payment"])
    fun findByCustomerId(customerId: java.util.UUID, pageable: Pageable): Page<Order>
    
    @EntityGraph(attributePaths = ["customer", "address", "payment"])
    fun findByStatus(status: OrderStatus, pageable: Pageable): Page<Order>

    @EntityGraph(attributePaths = ["customer", "address", "payment"])
    override fun findAll(pageable: Pageable): Page<Order>

    fun findByStatusAndCreatedAtBefore(status: OrderStatus, createdAt: OffsetDateTime): List<Order>

    @Query("SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o WHERE o.status IN :statuses")
    fun sumTotalAmountByStatusIn(statuses: List<OrderStatus>): BigDecimal

    @Query("SELECT o.status, COUNT(o) FROM Order o GROUP BY o.status")
    fun countOrdersByStatus(): List<Array<Any>>

    @Query(value = "SELECT i.product_name, SUM(i.quantity) as sold FROM order_items i JOIN orders o ON i.order_id = o.id WHERE o.status IN ('COMPLETED', 'PROCESSING') GROUP BY i.product_name ORDER BY sold DESC LIMIT 5", nativeQuery = true)
    fun findTopSellingProducts(): List<Array<Any>>
}
