package com.bakery.ecommerce.config

import io.jsonwebtoken.Claims
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.security.Keys
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.User
import org.springframework.stereotype.Component
import java.util.Date
import javax.crypto.SecretKey

@Component
class JwtTokenProvider(
    @Value("\${jwt.secret}")
    private val jwtSecret: String,
    
    @Value("\${jwt.expiration}")
    private val jwtExpirationMs: Long,
    
    @Value("\${jwt.refresh-expiration:604800000}") // 7 days default
    private val jwtRefreshExpirationMs: Long
) {
    private val key: SecretKey = Keys.hmacShaKeyFor(jwtSecret.toByteArray())

    fun generateToken(userId: String, role: String): String {
        val now = Date()
        val expiryDate = Date(now.time + jwtExpirationMs)

        return Jwts.builder()
            .subject(userId)
            .claim("role", role)
            .claim("type", "access")
            .issuedAt(now)
            .expiration(expiryDate)
            .signWith(key)
            .compact()
    }

    fun generateRefreshToken(userId: String): String {
        val now = Date()
        val expiryDate = Date(now.time + jwtRefreshExpirationMs)

        return Jwts.builder()
            .subject(userId)
            .claim("type", "refresh")
            .issuedAt(now)
            .expiration(expiryDate)
            .signWith(key)
            .compact()
    }

    fun getUserIdFromJWT(token: String): String {
        val claims = getClaims(token)
        return claims.subject
    }

    fun getRoleFromJWT(token: String): String {
        val claims = getClaims(token)
        return claims["role"] as String
    }

    fun validateToken(authToken: String): Boolean {
        try {
            Jwts.parser().verifyWith(key).build().parseSignedClaims(authToken)
            return true
        } catch (ex: Exception) {
            return false
        }
    }

    private fun getClaims(token: String): Claims {
        return Jwts.parser()
            .verifyWith(key)
            .build()
            .parseSignedClaims(token)
            .payload
    }

    fun getTokenTypeFromJWT(token: String): String {
        val claims = getClaims(token)
        return claims["type"] as String? ?: "access"
    }

    fun getAuthentication(token: String): Authentication {
        val type = getTokenTypeFromJWT(token)
        if (type != "access") {
            throw IllegalArgumentException("Invalid token type. Expected access token.")
        }
        val userId = getUserIdFromJWT(token)
        val role = getRoleFromJWT(token)
        
        val authorities = listOf(SimpleGrantedAuthority("ROLE_$role"))
        val principal = User(userId, "", authorities)
        
        return UsernamePasswordAuthenticationToken(principal, token, authorities)
    }
}
