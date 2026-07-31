package com.bakery.ecommerce.config.security

import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Component
import org.springframework.web.servlet.HandlerInterceptor

@Component
class RateLimitInterceptor(
    private val rateLimitingService: RateLimitingService
) : HandlerInterceptor {

    override fun preHandle(request: HttpServletRequest, response: HttpServletResponse, handler: Any): Boolean {
        // Simple IP based rate limiting
        val clientIp = request.remoteAddr
        val bucket = rateLimitingService.resolveBucket(clientIp)
        
        val probe = bucket.tryConsumeAndReturnRemaining(1)
        
        return if (probe.isConsumed) {
            response.setHeader("X-Rate-Limit-Remaining", probe.remainingTokens.toString())
            true
        } else {
            response.status = HttpStatus.TOO_MANY_REQUESTS.value()
            response.setHeader("X-Rate-Limit-Retry-After-Seconds", (probe.nanosToWaitForRefill / 1_000_000_000).toString())
            response.writer.write("Too Many Requests")
            false
        }
    }
}
