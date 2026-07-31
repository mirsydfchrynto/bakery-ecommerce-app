package com.bakery.ecommerce.domain.order

import com.bakery.ecommerce.common.BaseEntity
import com.bakery.ecommerce.common.BaseRepository
import jakarta.persistence.*
import org.springframework.stereotype.Repository
import java.math.BigDecimal

@Entity
@Table(name = "order_addresses")
class OrderAddress : BaseEntity() {
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false, unique = true)
    var order: Order? = null

    @Column(name = "recipient_name", nullable = false, length = 100)
    var recipientName: String = ""

    @Column(name = "phone_number", nullable = false, length = 20)
    var phoneNumber: String = ""

    @Column(name = "full_address", nullable = false, columnDefinition = "TEXT")
    var fullAddress: String = ""

    @Column(name = "latitude", nullable = false, precision = 10, scale = 8)
    var latitude: BigDecimal = BigDecimal.ZERO

    @Column(name = "longitude", nullable = false, precision = 11, scale = 8)
    var longitude: BigDecimal = BigDecimal.ZERO
}

@Repository
interface OrderAddressRepository : BaseRepository<OrderAddress> {
    fun findByOrderId(orderId: java.util.UUID): OrderAddress?
}
