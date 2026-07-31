package com.bakery.ecommerce.domain.iam

import com.bakery.ecommerce.common.BaseEntity
import com.bakery.ecommerce.common.BaseRepository
import jakarta.persistence.*
import org.hibernate.annotations.SQLRestriction
import org.springframework.stereotype.Repository

@Entity
@Table(name = "users")
@SQLRestriction("is_deleted = false")
class User : BaseEntity() {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "role_id", nullable = false)
    var role: Role? = null

    @Column(name = "username", nullable = false, length = 50)
    var username: String = ""

    @Column(name = "password_hash", nullable = false, length = 255)
    var passwordHash: String = ""

    @Column(name = "email", nullable = false, length = 100)
    var email: String = ""

    @Column(name = "phone_number", nullable = false, length = 20)
    var phoneNumber: String = ""

    @Column(name = "profile_picture_url", length = 500)
    var profilePictureUrl: String? = null

    @Column(name = "is_deleted", nullable = false)
    var isDeleted: Boolean = false

    @Column(name = "deleted_at")
    var deletedAt: java.time.OffsetDateTime? = null
}

@Repository
interface UserRepository : BaseRepository<User> {
    fun findByUsername(username: String): User?
    fun findByUsernameOrEmailOrPhoneNumber(username: String, email: String, phone: String): User?
    fun existsByUsername(username: String): Boolean
    fun existsByEmail(email: String): Boolean
    fun existsByPhoneNumber(phoneNumber: String): Boolean
}
