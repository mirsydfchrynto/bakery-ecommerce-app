package com.bakery.ecommerce.domain.system.event

import java.util.UUID

data class AuditEvent(
    val actorId: UUID?,
    val action: String,
    val resource: String,
    val entityId: UUID,
    val oldValue: String?,
    val newValue: String?,
    val ipAddress: String?,
    val device: String?
)
