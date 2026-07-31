package com.bakery.ecommerce.domain.catalog.service

import com.bakery.ecommerce.domain.catalog.Product
import com.bakery.ecommerce.domain.catalog.ProductImage
import com.bakery.ecommerce.domain.catalog.ProductImageRepository
import com.bakery.ecommerce.domain.catalog.ProductRepository
import com.bakery.ecommerce.domain.catalog.ProductStatus
import com.bakery.ecommerce.domain.catalog.dto.ProductDto
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class ProductService(
    private val productRepository: ProductRepository,
    private val productImageRepository: ProductImageRepository,
    private val inventoryRepository: com.bakery.ecommerce.domain.inventory.InventoryRepository
) {

    @org.springframework.cache.annotation.Cacheable(value = ["active_products"], key = "#pageable.pageNumber + '-' + #pageable.pageSize")
    @Transactional(readOnly = true)
    fun getActiveProducts(pageable: org.springframework.data.domain.Pageable): org.springframework.data.domain.Page<ProductDto> {
        val productPage = productRepository.findByStatus(ProductStatus.ACTIVE, pageable)
        if (productPage.isEmpty) return org.springframework.data.domain.Page.empty()
        
        val productIds = productPage.content.map { it.id!! }
        val images = productImageRepository.findByProductIdIn(productIds)
        val imagesByProduct = images.groupBy { it.product?.id }
        
        val inventories = inventoryRepository.findByProductIdIn(productIds)
        val inventoryByProduct = inventories.associateBy { it.product?.id }

        return productPage.map { 
            toProductDto(it, imagesByProduct[it.id] ?: emptyList(), inventoryByProduct[it.id]?.stock)
        }
    }

    @Transactional(readOnly = true)
    fun getAllProducts(pageable: org.springframework.data.domain.Pageable): org.springframework.data.domain.Page<ProductDto> {
        val productPage = productRepository.findAll(pageable)
        if (productPage.isEmpty) return org.springframework.data.domain.Page.empty()
        
        val productIds = productPage.content.map { it.id!! }
        val images = productImageRepository.findByProductIdIn(productIds)
        val imagesByProduct = images.groupBy { it.product?.id }
        
        val inventories = inventoryRepository.findByProductIdIn(productIds)
        val inventoryByProduct = inventories.associateBy { it.product?.id }

        return productPage.map { 
            toProductDto(it, imagesByProduct[it.id] ?: emptyList(), inventoryByProduct[it.id]?.stock)
        }
    }

    @org.springframework.cache.annotation.CacheEvict(value = ["active_products"], allEntries = true)
    @Transactional
    fun createProduct(request: com.bakery.ecommerce.domain.catalog.dto.CreateProductRequest): ProductDto {
        val product = Product().apply {
            name = request.name
            description = request.description
            price = request.price
            status = ProductStatus.ACTIVE
        }
        val savedProduct = productRepository.save(product)

        if (!request.imageUrl.isNullOrBlank()) {
            val image = ProductImage().apply {
                this.product = savedProduct
                this.url = request.imageUrl
                this.isPrimary = true
            }
            productImageRepository.save(image)
        }

        // Initialize Inventory with default stock of 100 for newly created products
        val inventory = com.bakery.ecommerce.domain.inventory.Inventory().apply {
            this.product = savedProduct
            this.stock = 100
            this.reservedStock = 0
            this.minimumStock = 5
            this.status = com.bakery.ecommerce.domain.inventory.InventoryStatus.IN_STOCK
        }
        inventoryRepository.save(inventory)

        return toProductDto(savedProduct)
    }

    @org.springframework.cache.annotation.CacheEvict(value = ["active_products"], allEntries = true)
    @Transactional
    fun updateProduct(id: java.util.UUID, request: com.bakery.ecommerce.domain.catalog.dto.UpdateProductRequest): ProductDto {
        val product = productRepository.findById(id).orElseThrow {
            com.bakery.ecommerce.exception.ResourceNotFoundException("CATALOG-001", "Product not found")
        }

        request.name?.let { product.name = it }
        request.description?.let { product.description = it }
        request.price?.let { product.price = it }
        request.status?.let { product.status = it }

        val savedProduct = productRepository.save(product)

        if (!request.imageUrl.isNullOrBlank()) {
            // override primary image or add new one
            val images = productImageRepository.findByProductId(savedProduct.id!!)
            images.forEach {
                it.isPrimary = false
                productImageRepository.save(it)
            }
            val newImage = ProductImage().apply {
                this.product = savedProduct
                this.url = request.imageUrl
                this.isPrimary = true
            }
            productImageRepository.save(newImage)
        }

        request.stock?.let { newStock ->
            val inventory = inventoryRepository.findByProductId(savedProduct.id!!)
            if (inventory != null) {
                inventory.stock = newStock
                inventoryRepository.save(inventory)
            }
        }

        return toProductDto(savedProduct)
    }

    @org.springframework.cache.annotation.CacheEvict(value = ["active_products"], allEntries = true)
    @Transactional
    fun deleteProduct(id: java.util.UUID) {
        val product = productRepository.findById(id).orElseThrow {
            com.bakery.ecommerce.exception.ResourceNotFoundException("CATALOG-001", "Product not found")
        }
        product.isDeleted = true
        product.deletedAt = java.time.OffsetDateTime.now()
        product.status = ProductStatus.ARCHIVED
        productRepository.save(product)
    }

    private fun toProductDto(product: Product): ProductDto {
        val images = productImageRepository.findByProductId(product.id!!)
        val inventory = inventoryRepository.findByProductId(product.id!!)
        return toProductDto(product, images, inventory?.stock)
    }

    private fun toProductDto(product: Product, images: List<ProductImage>, stock: Int? = null): ProductDto {
        val primaryImage = images.firstOrNull { it.isPrimary } ?: images.firstOrNull()
        
        return ProductDto(
            id = product.id.toString(),
            name = product.name,
            description = product.description,
            price = product.price,
            status = product.status,
            imageUrl = primaryImage?.url,
            categoryName = product.categories.firstOrNull()?.name,
            stock = stock
        )
    }
}
