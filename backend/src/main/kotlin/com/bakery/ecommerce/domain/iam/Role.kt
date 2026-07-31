package com.bakery.ecommerce.domain.iam

import com.bakery.ecommerce.common.BaseEntity
import com.bakery.ecommerce.common.BaseRepository
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import org.springframework.stereotype.Repository

@Entity
@Table(name = "roles")
class Role : BaseEntity() {
    @Column(name = "role_name", nullable = false, unique = true, length = 50)
    var roleName: String = ""

    @Column(name = "description", columnDefinition = "TEXT")
    var description: String? = null
}

@Repository
interface RoleRepository : BaseRepository<Role> {
    fun findByRoleName(roleName: String): Role?
}
