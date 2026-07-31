package com.bakery.ecommerce

import org.junit.jupiter.api.Test
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

class HashTest {
    @Test
    fun generateHash() {
        val encoder = BCryptPasswordEncoder()
        println("NEW_HASH: " + encoder.encode("irsyad1805"))
    }
}
