package com.bakery.ecommerce.domain.order.controller

import com.bakery.ecommerce.domain.order.dto.CheckoutRequestDto
import com.bakery.ecommerce.domain.order.dto.OrderResponseDto
import com.bakery.ecommerce.domain.order.service.OrderService
import com.bakery.ecommerce.exception.BaseResponse
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.security.SecurityRequirement
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/api/v1/orders")
@Tag(name = "Order", description = "Endpoints for Customer Orders")
@SecurityRequirement(name = "bearerAuth")
class OrderController(
    private val orderService: OrderService
) {

    @PostMapping
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Submit a checkout request")
    fun checkout(
        @AuthenticationPrincipal userDetails: UserDetails,
        @Valid @RequestBody request: CheckoutRequestDto,
        @RequestHeader(value = "Idempotency-Key", required = false) idempotencyKey: String?
    ): ResponseEntity<BaseResponse<OrderResponseDto>> {
        val customerId = UUID.fromString(userDetails.username) // Subject contains User ID
        val response = orderService.checkout(customerId, request)
        
        return ResponseEntity.status(201).body(
            BaseResponse.success(response, "Order created successfully")
        )
    }

    @GetMapping
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Get current user's order history")
    fun getMyOrders(
        @AuthenticationPrincipal userDetails: UserDetails,
        @org.springdoc.core.annotations.ParameterObject @org.springframework.data.web.PageableDefault(size = 10, sort = ["orderedAt"], direction = org.springframework.data.domain.Sort.Direction.DESC) pageable: org.springframework.data.domain.Pageable
    ): ResponseEntity<BaseResponse<org.springframework.data.domain.Page<OrderResponseDto>>> {
        val customerId = UUID.fromString(userDetails.username)
        val response = orderService.getMyOrders(customerId, pageable)
        
        return ResponseEntity.ok(
            BaseResponse.success(response, "Orders fetched successfully")
        )
    }

    @PutMapping("/{orderId}/cancel")
    @PreAuthorize("hasRole('CUSTOMER')")
    @Operation(summary = "Cancel an order (Customer only)")
    fun cancelOrder(
        @AuthenticationPrincipal userDetails: UserDetails,
        @PathVariable("orderId") orderId: UUID
    ): ResponseEntity<BaseResponse<OrderResponseDto>> {
        val customerId = UUID.fromString(userDetails.username)
        val response = orderService.cancelOrder(customerId, orderId)
        return ResponseEntity.ok(
            BaseResponse.success(response, "Order cancelled successfully")
        )
    }

    // --- ADMIN ENDPOINTS ---

    @GetMapping("/admin")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get ALL orders (Admin only)")
    fun getAllOrders(
        @org.springdoc.core.annotations.ParameterObject @org.springframework.data.web.PageableDefault(size = 10, sort = ["orderedAt"], direction = org.springframework.data.domain.Sort.Direction.DESC) pageable: org.springframework.data.domain.Pageable
    ): ResponseEntity<BaseResponse<org.springframework.data.domain.Page<OrderResponseDto>>> {
        val response = orderService.getAllOrders(null, pageable)
        return ResponseEntity.ok(
            BaseResponse.success(response, "All orders fetched successfully")
        )
    }

    @PutMapping("/admin/{orderId}/status")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Update Order Status (Admin only)")
    fun updateOrderStatus(
        @PathVariable("orderId") orderId: UUID,
        @RequestParam("status") status: com.bakery.ecommerce.domain.order.OrderStatus
    ): ResponseEntity<BaseResponse<OrderResponseDto>> {
        val response = orderService.updateOrderStatus(orderId, status)
        return ResponseEntity.ok(
            BaseResponse.success(response, "Order status updated to $status")
        )
    }
}
