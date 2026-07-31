package com.bakery.ecommerce.domain.iam.controller

import com.bakery.ecommerce.domain.iam.dto.ChangePasswordRequest
import com.bakery.ecommerce.domain.iam.dto.UpdateProfileRequest
import com.bakery.ecommerce.domain.iam.dto.UserDto
import com.bakery.ecommerce.domain.iam.service.UserService
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
@RequestMapping("/api/v1/users")
@Tag(name = "User Management", description = "Endpoints for user profile and account management")
@SecurityRequirement(name = "bearerAuth")
class UserController(
    private val userService: UserService
) {

    @GetMapping("/me")
    @PreAuthorize("hasAnyRole('CUSTOMER', 'ADMIN')")
    @Operation(summary = "Get current user profile")
    fun getProfile(
        @AuthenticationPrincipal userDetails: UserDetails
    ): ResponseEntity<BaseResponse<UserDto>> {
        val userId = UUID.fromString(userDetails.username)
        val response = userService.getProfile(userId)
        return ResponseEntity.ok(BaseResponse.success(response, "Profile retrieved successfully"))
    }

    @PutMapping("/me")
    @PreAuthorize("hasAnyRole('CUSTOMER', 'ADMIN')")
    @Operation(summary = "Update current user profile")
    fun updateProfile(
        @AuthenticationPrincipal userDetails: UserDetails,
        @Valid @RequestBody request: UpdateProfileRequest
    ): ResponseEntity<BaseResponse<UserDto>> {
        val userId = UUID.fromString(userDetails.username)
        val response = userService.updateProfile(userId, request)
        return ResponseEntity.ok(BaseResponse.success(response, "Profile updated successfully"))
    }

    @PostMapping("/me/password")
    @PreAuthorize("hasAnyRole('CUSTOMER', 'ADMIN')")
    @Operation(summary = "Change password")
    fun changePassword(
        @AuthenticationPrincipal userDetails: UserDetails,
        @Valid @RequestBody request: ChangePasswordRequest
    ): ResponseEntity<BaseResponse<Void>> {
        val userId = UUID.fromString(userDetails.username)
        userService.changePassword(userId, request)
        return ResponseEntity.ok(BaseResponse.success(null, "Password changed successfully"))
    }

    @DeleteMapping("/me")
    @PreAuthorize("hasAnyRole('CUSTOMER', 'ADMIN')")
    @Operation(summary = "Delete account (Soft delete)")
    fun deleteAccount(
        @AuthenticationPrincipal userDetails: UserDetails
    ): ResponseEntity<BaseResponse<Void>> {
        val userId = UUID.fromString(userDetails.username)
        userService.deleteAccount(userId)
        return ResponseEntity.ok(BaseResponse.success(null, "Account deleted successfully"))
    }
}
