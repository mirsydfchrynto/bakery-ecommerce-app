package com.bakery.ecommerce.domain.iam.service

import com.bakery.ecommerce.config.JwtTokenProvider
import com.bakery.ecommerce.domain.iam.Role
import com.bakery.ecommerce.domain.iam.RoleRepository
import com.bakery.ecommerce.domain.iam.User
import com.bakery.ecommerce.domain.iam.UserRepository
import com.bakery.ecommerce.domain.iam.dto.AuthResponse
import com.bakery.ecommerce.domain.iam.dto.LoginRequest
import com.bakery.ecommerce.domain.iam.dto.RegisterRequest
import com.bakery.ecommerce.domain.iam.dto.RefreshTokenRequest
import com.bakery.ecommerce.domain.iam.dto.UserDto
import com.bakery.ecommerce.exception.AuthException
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import com.bakery.ecommerce.domain.iam.PasswordResetToken
import com.bakery.ecommerce.domain.iam.PasswordResetTokenRepository
import com.bakery.ecommerce.domain.iam.dto.ForgotPasswordRequest
import com.bakery.ecommerce.domain.iam.dto.ResetPasswordRequest
import java.util.UUID
import org.springframework.transaction.annotation.Transactional

@Service
class AuthService(
    private val userRepository: UserRepository,
    private val roleRepository: RoleRepository,
    private val passwordEncoder: PasswordEncoder,
    private val jwtTokenProvider: JwtTokenProvider,
    private val passwordResetTokenRepository: PasswordResetTokenRepository
) {

    @Transactional
    fun register(request: RegisterRequest): AuthResponse {
        if (userRepository.existsByUsername(request.username)) {
            throw AuthException("AUTH-001", "Username already exists")
        }
        if (userRepository.existsByEmail(request.email)) {
            throw AuthException("AUTH-003", "Email already exists")
        }
        if (userRepository.existsByPhoneNumber(request.phoneNumber)) {
            throw AuthException("AUTH-004", "Phone number already exists")
        }

        val customerRole = roleRepository.findByRoleName("CUSTOMER") ?: Role().apply {
            roleName = "CUSTOMER"
            description = "Default customer role"
        }.also { roleRepository.save(it) }

        val user = User().apply {
            username = request.username
            email = request.email
            phoneNumber = request.phoneNumber
            passwordHash = passwordEncoder.encode(request.password)!!
            role = customerRole
        }
        userRepository.save(user)

        val token = jwtTokenProvider.generateToken(user.id.toString(), customerRole.roleName)
        val refreshToken = jwtTokenProvider.generateRefreshToken(user.id.toString())
        
        return AuthResponse(
            token = token,
            refreshToken = refreshToken,
            user = UserDto(user.id.toString(), user.username, user.email, user.phoneNumber, customerRole.roleName, user.profilePictureUrl)
        )
    }

    @Transactional(readOnly = true)
    fun login(request: LoginRequest): AuthResponse {
        val user = userRepository.findByUsernameOrEmailOrPhoneNumber(
            request.identifier, request.identifier, request.identifier
        ) ?: throw AuthException("AUTH-002", "Invalid credentials")

        if (!passwordEncoder.matches(request.password, user.passwordHash)) {
            throw AuthException("AUTH-002", "Invalid username or password")
        }

        val roleName = user.role?.roleName ?: "CUSTOMER"
        val token = jwtTokenProvider.generateToken(user.id.toString(), roleName)
        val refreshToken = jwtTokenProvider.generateRefreshToken(user.id.toString())

        return AuthResponse(
            token = token,
            refreshToken = refreshToken,
            user = UserDto(user.id.toString(), user.username, user.email, user.phoneNumber, roleName, user.profilePictureUrl)
        )
    }

    @Transactional(readOnly = true)
    fun refreshToken(request: RefreshTokenRequest): AuthResponse {
        if (!jwtTokenProvider.validateToken(request.refreshToken)) {
            throw AuthException("AUTH-005", "Invalid or expired refresh token")
        }

        val type = jwtTokenProvider.getTokenTypeFromJWT(request.refreshToken)
        if (type != "refresh") {
            throw AuthException("AUTH-006", "Invalid token type. Expected refresh token.")
        }

        val userIdStr = jwtTokenProvider.getUserIdFromJWT(request.refreshToken)
        val userId = UUID.fromString(userIdStr)
        val user = userRepository.findById(userId).orElseThrow {
            AuthException("AUTH-007", "User not found")
        }

        val roleName = user.role?.roleName ?: "CUSTOMER"
        val newToken = jwtTokenProvider.generateToken(user.id.toString(), roleName)
        val newRefreshToken = jwtTokenProvider.generateRefreshToken(user.id.toString())

        return AuthResponse(
            token = newToken,
            refreshToken = newRefreshToken,
            user = UserDto(user.id.toString(), user.username, user.email, user.phoneNumber, roleName, user.profilePictureUrl)
        )
    }

    @Transactional
    fun forgotPassword(request: ForgotPasswordRequest) {
        val user = userRepository.findByUsernameOrEmailOrPhoneNumber("", request.email, "")
            ?: return // Silently return for security reasons to prevent email enumeration

        // Delete any existing tokens for this user
        passwordResetTokenRepository.deleteByUser(user)

        // Generate a simple 6-digit OTP for this demo
        val otp = (100000..999999).random().toString()
        val resetToken = PasswordResetToken().apply {
            this.token = otp
            this.user = user
        }
        passwordResetTokenRepository.save(resetToken)

        // Simulating sending email
        println("=========================================================")
        println("MOCK EMAIL SENT TO: ${user.email}")
        println("SUBJECT: Your Password Reset OTP")
        println("OTP: $otp")
        println("=========================================================")
    }

    @Transactional
    fun resetPassword(request: ResetPasswordRequest) {
        val resetToken = passwordResetTokenRepository.findByToken(request.token)
            ?: throw AuthException("AUTH-008", "Invalid or expired reset token")

        if (resetToken.isExpired()) {
            passwordResetTokenRepository.delete(resetToken)
            throw AuthException("AUTH-008", "Invalid or expired reset token")
        }

        val user = resetToken.user!!
        user.passwordHash = passwordEncoder.encode(request.newPassword)!!
        userRepository.save(user)

        passwordResetTokenRepository.delete(resetToken)
    }
}
