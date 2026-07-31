package com.bakery.ecommerce.domain.iam.dto

import jakarta.validation.constraints.Email
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Pattern

data class LoginRequest(
    val identifier: String, // can be username, email, or phone number
    val password: String
)

data class RegisterRequest(
    @field:NotBlank(message = "Username is required")
    val username: String,
    
    @field:NotBlank(message = "Email is required")
    @field:Email(message = "Invalid email format")
    val email: String,
    
    @field:NotBlank(message = "Phone number is required")
    @field:Pattern(regexp = "^\\+?[0-9]{10,15}\$", message = "Invalid phone number format")
    val phoneNumber: String,
    
    @field:NotBlank(message = "Password is required")
    val password: String
)

data class AuthResponse(
    val token: String,
    val refreshToken: String? = null,
    val user: UserDto
)

data class RefreshTokenRequest(
    @field:NotBlank(message = "Refresh token is required")
    val refreshToken: String
)

data class UserDto(
    val id: String,
    val username: String,
    val email: String,
    val phoneNumber: String,
    val role: String,
    val profilePictureUrl: String? = null
)

data class ForgotPasswordRequest(
    @field:NotBlank(message = "Email is required")
    @field:Email(message = "Invalid email format")
    val email: String
)

data class ResetPasswordRequest(
    @field:NotBlank(message = "Token is required")
    val token: String,
    
    @field:NotBlank(message = "New password is required")
    val newPassword: String
)
