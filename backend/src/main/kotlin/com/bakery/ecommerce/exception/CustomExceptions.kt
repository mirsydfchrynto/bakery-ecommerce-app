package com.bakery.ecommerce.exception

abstract class BakeryException(
    val code: String,
    message: String
) : RuntimeException(message)

class BusinessException(code: String, message: String) : BakeryException(code, message)
class AuthException(code: String, message: String) : BakeryException(code, message)
class ResourceNotFoundException(code: String, message: String) : BakeryException(code, message)
