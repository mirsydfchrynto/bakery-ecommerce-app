package com.bakery.ecommerce.domain.catalog

import com.bakery.ecommerce.common.BaseEntity
import com.bakery.ecommerce.common.BaseRepository
import jakarta.persistence.*
import org.hibernate.annotations.SQLRestriction
import org.springframework.stereotype.Repository
import java.math.BigDecimal

enum class ProductStatus {
    ACTIVE, DRAFT, ARCHIVED
}

@Entity
@Table(name = "products")
@SQLRestriction("is_deleted = false")
class Product : BaseEntity() {
    @Column(name = "name", nullable = false, length = 100)
    var name: String = ""

    @Column(name = "description", columnDefinition = "TEXT")
    var description: String? = null

    @Column(name = "price", nullable = false, precision = 12, scale = 2)
    var price: BigDecimal = BigDecimal.ZERO

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    var status: ProductStatus = ProductStatus.DRAFT

    @Column(name = "is_deleted", nullable = false)
    var isDeleted: Boolean = false

    @Column(name = "deleted_at")
    var deletedAt: java.time.OffsetDateTime? = null

    @org.hibernate.annotations.BatchSize(size = 50)
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "product_categories",
        joinColumns = [JoinColumn(name = "product_id")],
        inverseJoinColumns = [JoinColumn(name = "category_id")]
    )
    var categories: MutableSet<Category> = mutableSetOf()
}

@Repository
interface ProductRepository : BaseRepository<Product> {
    fun findByStatus(status: ProductStatus, pageable: org.springframework.data.domain.Pageable): org.springframework.data.domain.Page<Product>
    
    override fun findAll(pageable: org.springframework.data.domain.Pageable): org.springframework.data.domain.Page<Product>
}
