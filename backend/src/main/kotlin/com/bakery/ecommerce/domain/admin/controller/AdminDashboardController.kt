package com.bakery.ecommerce.domain.admin.controller

import com.bakery.ecommerce.domain.admin.service.AdminDashboardService
import com.bakery.ecommerce.exception.BaseResponse
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.security.SecurityRequirement
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/admin/dashboard")
@Tag(name = "Admin Dashboard", description = "Endpoints for Admin Analytics Dashboard")
@SecurityRequirement(name = "bearerAuth")
class AdminDashboardController(
    private val dashboardService: AdminDashboardService
) {

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get Dashboard Analytics")
    fun getDashboardData(): ResponseEntity<BaseResponse<Map<String, Any>>> {
        val data = dashboardService.getDashboardAnalytics()
        return ResponseEntity.ok(BaseResponse.success(data, "Dashboard data retrieved successfully"))
    }
}
