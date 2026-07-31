package com.bakery.ecommerce.exception

import java.time.OffsetDateTime
import java.time.ZoneOffset

data class BaseResponse<T>(
    val success: Boolean,
    val code: String? = null,
    val message: String,
    val timestamp: OffsetDateTime = OffsetDateTime.now(ZoneOffset.UTC),
    val data: T? = null
) {
    companion object {
        fun <T> success(data: T?, message: String = "Success"): BaseResponse<T> {
            return BaseResponse(
                success = true,
                message = message,
                data = data
            )
        }

        fun <T> error(code: String, message: String): BaseResponse<T> {
            return BaseResponse(
                success = false,
                code = code,
                message = message
            )
        }
    }
}
