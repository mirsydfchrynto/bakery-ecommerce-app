package com.bakery.ecommerce.domain.catalog.controller

import com.bakery.ecommerce.domain.catalog.ProductStatus
import com.bakery.ecommerce.exception.BaseResponse
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

import com.bakery.ecommerce.domain.catalog.dto.ProductDto
import com.bakery.ecommerce.domain.catalog.service.ProductService

@RestController
@RequestMapping("/api/v1/products")
@Tag(name = "Catalog", description = "Endpoints for catalog browsing (Public)")
class ProductController(
    private val productService: ProductService
) {

    @GetMapping
    @Operation(summary = "Get all active products with pagination")
    fun getActiveProducts(
        @org.springdoc.core.annotations.ParameterObject @org.springframework.data.web.PageableDefault(size = 20) pageable: org.springframework.data.domain.Pageable
    ): ResponseEntity<BaseResponse<org.springframework.data.domain.Page<ProductDto>>> {
        val products = productService.getActiveProducts(pageable)
        return ResponseEntity.ok(
            BaseResponse.success(
                products,
                "Data retrieved successfully"
            )
        )
    }

    // --- ADMIN ENDPOINTS ---

    @GetMapping("/admin")
    @org.springframework.security.access.prepost.PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all products including inactive (Admin only) with pagination")
    fun getAllProductsForAdmin(
        @org.springdoc.core.annotations.ParameterObject @org.springframework.data.web.PageableDefault(size = 20) pageable: org.springframework.data.domain.Pageable
    ): ResponseEntity<BaseResponse<org.springframework.data.domain.Page<ProductDto>>> {
        val products = productService.getAllProducts(pageable)
        return ResponseEntity.ok(
            BaseResponse.success(products, "All products fetched successfully")
        )
    }

    @org.springframework.web.bind.annotation.PostMapping("/admin")
    @org.springframework.security.access.prepost.PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Create a new product (Admin only)")
    fun createProduct(
        @org.springframework.web.bind.annotation.RequestBody request: com.bakery.ecommerce.domain.catalog.dto.CreateProductRequest
    ): ResponseEntity<BaseResponse<ProductDto>> {
        val product = productService.createProduct(request)
        return ResponseEntity.status(201).body(
            BaseResponse.success(product, "Product created successfully")
        )
    }

    @org.springframework.web.bind.annotation.PutMapping("/admin/{id}")
    @org.springframework.security.access.prepost.PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Update a product (Admin only)")
    fun updateProduct(
        @org.springframework.web.bind.annotation.PathVariable id: java.util.UUID,
        @org.springframework.web.bind.annotation.RequestBody request: com.bakery.ecommerce.domain.catalog.dto.UpdateProductRequest
    ): ResponseEntity<BaseResponse<ProductDto>> {
        val product = productService.updateProduct(id, request)
        return ResponseEntity.ok(
            BaseResponse.success(product, "Product updated successfully")
        )
    }

    @org.springframework.web.bind.annotation.DeleteMapping("/admin/{id}")
    @org.springframework.security.access.prepost.PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Archive/Delete a product (Admin only)")
    fun deleteProduct(
        @org.springframework.web.bind.annotation.PathVariable id: java.util.UUID
    ): ResponseEntity<BaseResponse<Void>> {
        productService.deleteProduct(id)
        return ResponseEntity.ok(
            BaseResponse.success(null, "Product deleted successfully")
        )
    }
}
