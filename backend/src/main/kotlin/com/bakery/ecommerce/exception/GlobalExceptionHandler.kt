package com.bakery.ecommerce.exception

import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.access.AccessDeniedException
import org.springframework.web.bind.MethodArgumentNotValidException
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler

@ControllerAdvice
class GlobalExceptionHandler {
    private val log = LoggerFactory.getLogger(GlobalExceptionHandler::class.java)

    @ExceptionHandler(BusinessException::class)
    fun handleBusinessException(ex: BusinessException): ResponseEntity<BaseResponse<Nothing>> {
        log.warn("Business exception: {} - {}", ex.code, ex.message)
        return ResponseEntity.status(HttpStatus.CONFLICT)
            .body(BaseResponse.error(ex.code, ex.message ?: "Conflict"))
    }

    @ExceptionHandler(AuthException::class)
    fun handleAuthException(ex: AuthException): ResponseEntity<BaseResponse<Nothing>> {
        log.warn("Auth exception: {} - {}", ex.code, ex.message)
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(BaseResponse.error(ex.code, ex.message ?: "Unauthorized"))
    }

    @ExceptionHandler(ResourceNotFoundException::class)
    fun handleResourceNotFoundException(ex: ResourceNotFoundException): ResponseEntity<BaseResponse<Nothing>> {
        log.warn("Resource not found: {} - {}", ex.code, ex.message)
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(BaseResponse.error(ex.code, ex.message ?: "Not Found"))
    }

    @ExceptionHandler(MethodArgumentNotValidException::class)
    fun handleValidationExceptions(ex: MethodArgumentNotValidException): ResponseEntity<BaseResponse<Nothing>> {
        val errors = ex.bindingResult.fieldErrors.map { "${it.field}: ${it.defaultMessage}" }.joinToString(", ")
        log.warn("Validation error: {}", errors)
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(BaseResponse.error("VAL-001", errors))
    }

    @ExceptionHandler(AccessDeniedException::class)
    fun handleAccessDeniedException(ex: AccessDeniedException): ResponseEntity<BaseResponse<Nothing>> {
        log.warn("Access denied: {}", ex.message)
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
            .body(BaseResponse.error("AUTH-003", "Access Denied"))
    }

    @ExceptionHandler(IllegalArgumentException::class)
    fun handleIllegalArgumentException(ex: IllegalArgumentException): ResponseEntity<BaseResponse<Nothing>> {
        log.warn("Illegal argument: {}", ex.message)
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(BaseResponse.error("REQ-001", ex.message ?: "Bad Request"))
    }

    @ExceptionHandler(org.springframework.web.multipart.MaxUploadSizeExceededException::class)
    fun handleMaxSizeException(ex: org.springframework.web.multipart.MaxUploadSizeExceededException): ResponseEntity<BaseResponse<Nothing>> {
        log.warn("File too large: {}", ex.message)
        return ResponseEntity.status(HttpStatus.PAYLOAD_TOO_LARGE)
            .body(BaseResponse.error("REQ-002", "File size exceeds the maximum limit (1MB). Please upload a smaller image."))
    }

    @ExceptionHandler(Exception::class)
    fun handleGenericException(ex: Exception): ResponseEntity<BaseResponse<Nothing>> {
        log.error("Internal server error", ex)
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(BaseResponse.error("SYS-001", "Internal Server Error"))
    }
}
