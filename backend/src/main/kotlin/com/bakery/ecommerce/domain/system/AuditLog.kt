package com.bakery.ecommerce.domain.system

import com.bakery.ecommerce.common.BaseEntity
import com.bakery.ecommerce.common.BaseRepository
import com.bakery.ecommerce.domain.iam.User
import jakarta.persistence.*
import org.hibernate.annotations.JdbcTypeCode
import org.hibernate.type.SqlTypes
import org.springframework.stereotype.Repository
import java.time.OffsetDateTime
import java.util.UUID

@Entity
@Table(name = "audit_logs")
class AuditLog : BaseEntity() {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "actor")
    var actor: User? = null

    @Column(name = "action", nullable = false, length = 100)
    var action: String = ""

    @Column(name = "resource", nullable = false, length = 50)
    var resource: String = ""

    @Column(name = "entity_id", nullable = false)
    var entityId: UUID? = null

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "old_value")
    var oldValue: String? = null

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "new_value")
    var newValue: String? = null

    @Column(name = "ip_address", length = 45)
    var ipAddress: String? = null

    @Column(name = "device", length = 255)
    var device: String? = null

    @Column(name = "timestamp", nullable = false)
    var timestamp: OffsetDateTime = OffsetDateTime.now()
}

@Repository
interface AuditLogRepository : BaseRepository<AuditLog>
