package com.bakery.ecommerce.domain.iam.service

import com.bakery.ecommerce.domain.iam.UserRepository
import com.bakery.ecommerce.domain.iam.dto.ChangePasswordRequest
import com.bakery.ecommerce.domain.iam.dto.UpdateProfileRequest
import com.bakery.ecommerce.domain.iam.dto.UserDto
import com.bakery.ecommerce.exception.AuthException
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Service
class UserService(
    private val userRepository: UserRepository,
    private val passwordEncoder: PasswordEncoder
) {

    @Transactional(readOnly = true)
    fun getAllUsers(pageable: org.springframework.data.domain.Pageable): org.springframework.data.domain.Page<UserDto> {
        return userRepository.findAll(pageable).map { user ->
            val roleName = user.role?.roleName ?: "CUSTOMER"
            UserDto(user.id.toString(), user.username, user.email, user.phoneNumber, roleName, user.profilePictureUrl)
        }
    }

    @Transactional(readOnly = true)
    fun getProfile(userId: UUID): UserDto {
        val user = userRepository.findById(userId).orElseThrow {
            AuthException("USER-001", "User not found")
        }
        val roleName = user.role?.roleName ?: "CUSTOMER"
        return UserDto(user.id.toString(), user.username, user.email, user.phoneNumber, roleName, user.profilePictureUrl)
    }

    @Transactional
    fun updateProfile(userId: UUID, request: UpdateProfileRequest): UserDto {
        val user = userRepository.findById(userId).orElseThrow {
            AuthException("USER-001", "User not found")
        }

        if (user.username != request.username && userRepository.existsByUsername(request.username)) {
            throw AuthException("USER-002", "Username already exists")
        }
        if (user.email != request.email && userRepository.existsByEmail(request.email)) {
            throw AuthException("USER-003", "Email already exists")
        }
        if (user.phoneNumber != request.phoneNumber && userRepository.existsByPhoneNumber(request.phoneNumber)) {
            throw AuthException("USER-004", "Phone number already exists")
        }

        user.username = request.username
        user.email = request.email
        user.phoneNumber = request.phoneNumber
        
        if (request.profilePictureUrl != null) {
            user.profilePictureUrl = request.profilePictureUrl
        }
        
        userRepository.save(user)

        val roleName = user.role?.roleName ?: "CUSTOMER"
        return UserDto(user.id.toString(), user.username, user.email, user.phoneNumber, roleName, user.profilePictureUrl)
    }

    @Transactional
    fun changePassword(userId: UUID, request: ChangePasswordRequest) {
        val user = userRepository.findById(userId).orElseThrow {
            AuthException("USER-001", "User not found")
        }

        if (!passwordEncoder.matches(request.oldPassword, user.passwordHash)) {
            throw AuthException("USER-005", "Incorrect old password")
        }

        user.passwordHash = passwordEncoder.encode(request.newPassword)!!
        userRepository.save(user)
    }

    @Transactional
    fun deleteAccount(userId: UUID) {
        val user = userRepository.findById(userId).orElseThrow {
            AuthException("USER-001", "User not found")
        }
        
        // Soft delete implementation
        user.isDeleted = true
        user.deletedAt = java.time.OffsetDateTime.now()
        
        // Randomize personal data to comply with data privacy policies if fully needed, 
        // but simple soft delete is enough for MVP.
        userRepository.save(user)
    }
}
