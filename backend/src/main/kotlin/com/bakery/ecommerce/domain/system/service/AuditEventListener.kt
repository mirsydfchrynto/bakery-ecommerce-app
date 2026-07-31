package com.bakery.ecommerce.domain.system.service

import com.bakery.ecommerce.domain.iam.UserRepository
import com.bakery.ecommerce.domain.system.AuditLog
import com.bakery.ecommerce.domain.system.AuditLogRepository
import com.bakery.ecommerce.domain.system.event.AuditEvent
import org.springframework.context.event.EventListener
import org.springframework.scheduling.annotation.Async
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class AuditEventListener(
    private val auditLogRepository: AuditLogRepository,
    private val userRepository: UserRepository
) {

    @Async
    @EventListener
    @Transactional
    fun handleAuditEvent(event: AuditEvent) {
        val auditLog = AuditLog().apply {
            this.actor = event.actorId?.let { userRepository.findById(it).orElse(null) }
            this.action = event.action
            this.resource = event.resource
            this.entityId = event.entityId
            this.oldValue = event.oldValue
            this.newValue = event.newValue
            this.ipAddress = event.ipAddress
            this.device = event.device
        }
        auditLogRepository.save(auditLog)
    }
}
