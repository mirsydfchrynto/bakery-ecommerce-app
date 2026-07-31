package com.bakery.ecommerce.domain.iam.dto

import jakarta.validation.constraints.Email
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Pattern

data class UpdateProfileRequest(
    @field:NotBlank(message = "Username is required")
    val username: String,
    
    @field:NotBlank(message = "Email is required")
    @field:Email(message = "Invalid email format")
    val email: String,
    
    @field:NotBlank(message = "Phone number is required")
    @field:Pattern(regexp = "^\\+?[0-9]{10,15}\$", message = "Invalid phone number format")
    val phoneNumber: String,

    val profilePictureUrl: String? = null
)

data class ChangePasswordRequest(
    @field:NotBlank(message = "Old password is required")
    val oldPassword: String,
    
    @field:NotBlank(message = "New password is required")
    val newPassword: String
)
