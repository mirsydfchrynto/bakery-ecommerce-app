package com.bakery.ecommerce.domain.payment

import com.bakery.ecommerce.common.BaseEntity
import com.bakery.ecommerce.common.BaseRepository
import com.bakery.ecommerce.domain.iam.User
import com.bakery.ecommerce.domain.order.Order
import jakarta.persistence.*
import org.springframework.stereotype.Repository
import java.math.BigDecimal
import java.time.OffsetDateTime

enum class PaymentStatus {
    PENDING, VERIFYING, APPROVED, REJECTED
}

@Entity
@com.fasterxml.jackson.annotation.JsonIgnoreProperties(value = ["hibernateLazyInitializer", "handler"])
@Table(name = "payments")
class Payment : BaseEntity() {
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id", nullable = false, unique = true)
    @com.fasterxml.jackson.annotation.JsonIgnore
    var order: Order? = null

    @Column(name = "payment_reference", length = 50)
    var paymentReference: String? = null

    @Column(name = "payment_method", nullable = false, length = 50)
    var paymentMethod: String = ""

    @Column(name = "bank_name", nullable = false, length = 50)
    var bankName: String = ""

    @Column(name = "account_name", nullable = false, length = 100)
    var accountName: String = ""

    @Column(name = "transfer_amount", nullable = false, precision = 12, scale = 2)
    var transferAmount: BigDecimal = BigDecimal.ZERO

    @Column(name = "payment_proof_urls", columnDefinition = "TEXT")
    var paymentProofUrls: String = "[]"


    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false, length = 30)
    var paymentStatus: PaymentStatus = PaymentStatus.VERIFYING

    @Column(name = "rejection_reason", columnDefinition = "TEXT")
    var rejectionReason: String? = null

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "verified_by")
    @com.fasterxml.jackson.annotation.JsonIgnore
    var verifiedBy: User? = null

    @Column(name = "verified_at")
    var verifiedAt: OffsetDateTime? = null
}

@Repository
interface PaymentRepository : BaseRepository<Payment> {
    fun findByOrderId(orderId: java.util.UUID): Payment?
}
