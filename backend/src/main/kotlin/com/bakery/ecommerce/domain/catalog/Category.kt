package com.bakery.ecommerce.domain.catalog

import com.bakery.ecommerce.common.BaseEntity
import com.bakery.ecommerce.common.BaseRepository
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import org.springframework.stereotype.Repository

@Entity
@Table(name = "categories")
class Category : BaseEntity() {
    @Column(name = "name", nullable = false, unique = true, length = 100)
    var name: String = ""

    @Column(name = "slug", nullable = false, unique = true, length = 100)
    var slug: String = ""
}

@Repository
interface CategoryRepository : BaseRepository<Category> {
    fun findBySlug(slug: String): Category?
}
