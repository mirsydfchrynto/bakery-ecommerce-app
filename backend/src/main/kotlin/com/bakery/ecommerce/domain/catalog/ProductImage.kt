package com.bakery.ecommerce.domain.catalog

import com.bakery.ecommerce.common.BaseEntity
import com.bakery.ecommerce.common.BaseRepository
import jakarta.persistence.*
import org.springframework.stereotype.Repository

@Entity
@Table(name = "product_images")
class ProductImage : BaseEntity() {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    var product: Product? = null

    @Column(name = "url", nullable = false, length = 255)
    var url: String = ""

    @Column(name = "alt_text", length = 100)
    var altText: String? = null

    @Column(name = "is_primary", nullable = false)
    var isPrimary: Boolean = false
}

@Repository
interface ProductImageRepository : BaseRepository<ProductImage> {
    fun findByProductId(productId: java.util.UUID): List<ProductImage>
    fun findByProductIdIn(productIds: List<java.util.UUID>): List<ProductImage>
}
