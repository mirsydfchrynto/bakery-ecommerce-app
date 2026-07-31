package com.bakery.ecommerce.domain.iam

import com.bakery.ecommerce.common.BaseEntity
import jakarta.persistence.*
import org.springframework.stereotype.Repository
import java.time.OffsetDateTime

@Entity
@Table(name = "password_reset_tokens")
class PasswordResetToken : BaseEntity() {
    @Column(name = "token", nullable = false, unique = true)
    var token: String = ""

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    var user: User? = null

    @Column(name = "expiry_date", nullable = false)
    var expiryDate: OffsetDateTime = OffsetDateTime.now().plusHours(1)

    fun isExpired(): Boolean {
        return OffsetDateTime.now().isAfter(expiryDate)
    }
}

@Repository
interface PasswordResetTokenRepository : org.springframework.data.jpa.repository.JpaRepository<PasswordResetToken, java.util.UUID> {
    fun findByToken(token: String): PasswordResetToken?
    fun deleteByUser(user: User)
}
