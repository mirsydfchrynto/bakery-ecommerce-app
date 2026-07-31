package com.bakery.ecommerce.domain.inventory

import com.bakery.ecommerce.common.BaseEntity
import com.bakery.ecommerce.common.BaseRepository
import com.bakery.ecommerce.domain.catalog.Product
import jakarta.persistence.*
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.data.jpa.repository.Lock
import jakarta.persistence.LockModeType
import org.springframework.stereotype.Repository
import java.util.UUID

enum class InventoryStatus {
    IN_STOCK, OUT_OF_STOCK
}

@Entity
@Table(name = "inventories")
class Inventory : BaseEntity() {
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false, unique = true)
    var product: Product? = null

    @Column(name = "stock", nullable = false)
    var stock: Int = 0

    @Column(name = "reserved_stock", nullable = false)
    var reservedStock: Int = 0

    @Column(name = "minimum_stock", nullable = false)
    var minimumStock: Int = 5

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    var status: InventoryStatus = InventoryStatus.IN_STOCK

    fun getAvailableStock(): Int {
        return stock - reservedStock
    }
}

@Repository
interface InventoryRepository : BaseRepository<Inventory> {
    fun findByProductId(productId: UUID): Inventory?
    fun findByProductIdIn(productIds: List<UUID>): List<Inventory>

    @Query(value = "SELECT * FROM inventories WHERE product_id = :productId FOR UPDATE", nativeQuery = true)
    fun findByProductIdForUpdate(@Param("productId") productId: UUID): Inventory?
}
