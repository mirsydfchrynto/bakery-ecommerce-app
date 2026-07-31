package com.bakery.ecommerce.domain.iam.controller

import com.bakery.ecommerce.domain.iam.dto.UserDto
import com.bakery.ecommerce.domain.iam.service.UserService
import com.bakery.ecommerce.exception.BaseResponse
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.security.SecurityRequirement
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping("/api/v1/admin/users")
@Tag(name = "Admin User Management", description = "Endpoints for Admin to manage users")
@SecurityRequirement(name = "bearerAuth")
class AdminUserController(
    private val userService: UserService
) {

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Get all users (Admin only)")
    fun getAllUsers(
        @org.springdoc.core.annotations.ParameterObject @org.springframework.data.web.PageableDefault(size = 20) pageable: org.springframework.data.domain.Pageable
    ): ResponseEntity<BaseResponse<org.springframework.data.domain.Page<UserDto>>> {
        val users = userService.getAllUsers(pageable)
        return ResponseEntity.ok(
            BaseResponse.success(users, "Users fetched successfully")
        )
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Delete user (Admin only)")
    fun deleteUser(@PathVariable id: UUID): ResponseEntity<BaseResponse<Void>> {
        userService.deleteAccount(id)
        return ResponseEntity.ok(BaseResponse.success(null, "User deleted successfully"))
    }
}
