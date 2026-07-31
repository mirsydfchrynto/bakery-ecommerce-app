package com.bakery.ecommerce.config.security

import io.github.bucket4j.Bandwidth
import io.github.bucket4j.Bucket
import io.github.bucket4j.Refill
import org.springframework.stereotype.Service
import java.time.Duration
import java.util.concurrent.ConcurrentHashMap

@Service
class RateLimitingService {

    private val buckets = ConcurrentHashMap<String, Bucket>()

    fun resolveBucket(key: String): Bucket {
        return buckets.computeIfAbsent(key) {
            Bucket.builder()
                .addLimit { limit -> 
                    limit.capacity(100).refillGreedy(100, Duration.ofMinutes(1)) 
                }
                .build()
        }
    }
}
