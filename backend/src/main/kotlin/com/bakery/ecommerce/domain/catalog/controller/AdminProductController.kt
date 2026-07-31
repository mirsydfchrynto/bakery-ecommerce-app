package com.bakery.ecommerce.domain.catalog.controller

import com.bakery.ecommerce.domain.catalog.dto.CreateProductRequest
import com.bakery.ecommerce.domain.catalog.dto.ProductDto
import com.bakery.ecommerce.domain.catalog.dto.UpdateProductRequest
import com.bakery.ecommerce.domain.catalog.service.ProductService
import com.bakery.ecommerce.exception.BaseResponse
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.security.SecurityRequirement
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/api/v1/admin/products")
@Tag(name = "Admin Catalog", description = "Endpoints for Admin to manage products")
@SecurityRequirement(name = "bearerAuth")
class AdminProductController(
    private val productService: ProductService
) {

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all products including drafts and archived (Admin only)")
    fun getAllProducts(
        @org.springdoc.core.annotations.ParameterObject @org.springframework.data.web.PageableDefault(size = 20) pageable: org.springframework.data.domain.Pageable
    ): ResponseEntity<BaseResponse<org.springframework.data.domain.Page<ProductDto>>> {
        val products = productService.getAllProducts(pageable)
        return ResponseEntity.ok(
            BaseResponse.success(products, "Products fetched successfully")
        )
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Create a new product (Admin only)")
    fun createProduct(@RequestBody request: CreateProductRequest): ResponseEntity<BaseResponse<ProductDto>> {
        val product = productService.createProduct(request)
        return ResponseEntity.status(201).body(
            BaseResponse.success(product, "Product created successfully")
        )
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Update an existing product (Admin only)")
    fun updateProduct(
        @PathVariable id: UUID,
        @RequestBody request: UpdateProductRequest
    ): ResponseEntity<BaseResponse<ProductDto>> {
        val product = productService.updateProduct(id, request)
        return ResponseEntity.ok(
            BaseResponse.success(product, "Product updated successfully")
        )
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Soft delete a product (Admin only)")
    fun deleteProduct(@PathVariable id: UUID): ResponseEntity<BaseResponse<Unit>> {
        productService.deleteProduct(id)
        return ResponseEntity.ok(
            BaseResponse.success(Unit, "Product deleted successfully")
        )
    }
}
