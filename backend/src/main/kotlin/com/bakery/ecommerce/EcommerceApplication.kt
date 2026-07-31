package com.bakery.ecommerce

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.data.jpa.repository.config.EnableJpaAuditing
import org.springframework.scheduling.annotation.EnableAsync
import org.springframework.scheduling.annotation.EnableScheduling
import org.springframework.context.annotation.Bean
import org.springframework.data.auditing.DateTimeProvider
import java.time.OffsetDateTime
import java.util.Optional

@SpringBootApplication
@EnableJpaAuditing(dateTimeProviderRef = "offsetDateTimeProvider")
@EnableAsync
@EnableScheduling
@org.springframework.cache.annotation.EnableCaching
class EcommerceApplication {
    @Bean
    fun offsetDateTimeProvider(): DateTimeProvider {
        return DateTimeProvider { Optional.of(OffsetDateTime.now()) }
    }
}

fun main(args: Array<String>) {
	runApplication<EcommerceApplication>(*args)
}
