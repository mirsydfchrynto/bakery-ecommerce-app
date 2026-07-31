package com.bakery.ecommerce.domain.iam.controller

import com.bakery.ecommerce.exception.BaseResponse
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

import jakarta.validation.Valid
import com.bakery.ecommerce.domain.iam.dto.AuthResponse
import com.bakery.ecommerce.domain.iam.dto.LoginRequest
import com.bakery.ecommerce.domain.iam.dto.RegisterRequest
import com.bakery.ecommerce.domain.iam.service.AuthService

@RestController
@RequestMapping("/api/v1/auth")
@Tag(name = "Authentication", description = "Endpoints for user login and registration")
class AuthController(
    private val authService: AuthService
) {

    @PostMapping("/login")
    @Operation(summary = "Login to get JWT Token")
    fun login(@RequestBody request: LoginRequest): ResponseEntity<BaseResponse<AuthResponse>> {
        val response = authService.login(request)
        return ResponseEntity.ok(
            BaseResponse.success(
                response,
                "Login successful"
            )
        )
    }

    @PostMapping("/register")
    @Operation(summary = "Register a new customer")
    fun register(@Valid @RequestBody request: RegisterRequest): ResponseEntity<BaseResponse<AuthResponse>> {
        val response = authService.register(request)
        return ResponseEntity.status(201).body(
            BaseResponse.success(
                response,
                "Registration successful"
            )
        )
    }

    @PostMapping("/refresh")
    @Operation(summary = "Refresh JWT Token")
    fun refresh(@Valid @RequestBody request: com.bakery.ecommerce.domain.iam.dto.RefreshTokenRequest): ResponseEntity<BaseResponse<AuthResponse>> {
        val response = authService.refreshToken(request)
        return ResponseEntity.ok(
            BaseResponse.success(
                response,
                "Token refreshed successfully"
            )
        )
    }

    @PostMapping("/forgot-password")
    @Operation(summary = "Request password reset OTP")
    fun forgotPassword(@Valid @RequestBody request: com.bakery.ecommerce.domain.iam.dto.ForgotPasswordRequest): ResponseEntity<BaseResponse<Void>> {
        authService.forgotPassword(request)
        return ResponseEntity.ok(
            BaseResponse.success(
                null,
                "If the email is registered, an OTP has been sent."
            )
        )
    }

    @PostMapping("/reset-password")
    @Operation(summary = "Reset password using OTP")
    fun resetPassword(@Valid @RequestBody request: com.bakery.ecommerce.domain.iam.dto.ResetPasswordRequest): ResponseEntity<BaseResponse<Void>> {
        authService.resetPassword(request)
        return ResponseEntity.ok(
            BaseResponse.success(
                null,
                "Password reset successfully."
            )
        )
    }
}
