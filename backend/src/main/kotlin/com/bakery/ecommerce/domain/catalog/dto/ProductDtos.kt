package com.bakery.ecommerce.domain.catalog.dto

import com.bakery.ecommerce.domain.catalog.ProductStatus
import java.math.BigDecimal

data class ProductDto(
    val id: String,
    val name: String,
    val description: String?,
    val price: BigDecimal,
    val status: ProductStatus,
    val imageUrl: String?,
    val categoryName: String?,
    val stock: Int? = null
)

data class CreateProductRequest(
    val name: String,
    val description: String?,
    val price: BigDecimal,
    val imageUrl: String?
)

data class UpdateProductRequest(
    val name: String?,
    val description: String?,
    val price: BigDecimal?,
    val status: ProductStatus?,
    val imageUrl: String?,
    val stock: Int? = null
)
