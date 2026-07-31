package com.bakery.ecommerce.domain.payment.service

import com.bakery.ecommerce.domain.iam.UserRepository
import com.bakery.ecommerce.domain.inventory.InventoryRepository
import com.bakery.ecommerce.domain.order.OrderItemRepository
import com.bakery.ecommerce.domain.order.OrderRepository
import com.bakery.ecommerce.domain.order.OrderStatus
import com.bakery.ecommerce.domain.payment.PaymentRepository
import com.bakery.ecommerce.domain.payment.PaymentStatus
import com.bakery.ecommerce.domain.payment.dto.PaymentResponseDto
import com.bakery.ecommerce.domain.payment.dto.RejectPaymentRequestDto
import com.bakery.ecommerce.domain.payment.mapper.PaymentMapper
import com.bakery.ecommerce.domain.system.event.AuditEvent
import com.bakery.ecommerce.exception.BusinessException
import com.bakery.ecommerce.exception.ResourceNotFoundException
import org.springframework.context.ApplicationEventPublisher
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.OffsetDateTime
import java.util.UUID

@Service
class AdminPaymentService(
    private val paymentRepository: PaymentRepository,
    private val orderRepository: OrderRepository,
    private val orderItemRepository: OrderItemRepository,
    private val inventoryRepository: InventoryRepository,
    private val userRepository: UserRepository,
    private val paymentMapper: PaymentMapper,
    private val eventPublisher: ApplicationEventPublisher
) {

    @Transactional
    fun approvePayment(paymentId: UUID, adminId: UUID): PaymentResponseDto {
        val admin = userRepository.findById(adminId)
            .orElseThrow { ResourceNotFoundException("USER-001", "Admin not found") }

        val payment = paymentRepository.findById(paymentId)
            .orElseThrow { ResourceNotFoundException("PAYMENT-001", "Payment not found") }

        if (payment.paymentStatus != PaymentStatus.VERIFYING) {
            throw BusinessException("PAYMENT-005", "Payment is not in VERIFYING state")
        }

        // Update Payment
        payment.paymentStatus = PaymentStatus.APPROVED
        payment.verifiedBy = admin
        payment.verifiedAt = OffsetDateTime.now()
        val savedPayment = paymentRepository.save(payment)

        // Update Order
        val order = payment.order!!
        order.status = OrderStatus.PROCESSING
        orderRepository.save(order)

        // Deduct Stock is handled by OrderService when order status becomes COMPLETED.
        // Payment approval only updates status to PROCESSING, items remain reserved.

        // Audit Log Event
        eventPublisher.publishEvent(
            AuditEvent(
                actorId = adminId,
                action = "APPROVE_PAYMENT",
                resource = "payments",
                entityId = paymentId,
                oldValue = "VERIFYING",
                newValue = "APPROVED",
                ipAddress = null, // Can be injected from WebRequestContext
                device = null
            )
        )

        return paymentMapper.toResponseDto(savedPayment)
    }

    @Transactional
    fun rejectPayment(paymentId: UUID, adminId: UUID, request: RejectPaymentRequestDto): PaymentResponseDto {
        val admin = userRepository.findById(adminId)
            .orElseThrow { ResourceNotFoundException("USER-001", "Admin not found") }

        val payment = paymentRepository.findById(paymentId)
            .orElseThrow { ResourceNotFoundException("PAYMENT-001", "Payment not found") }

        if (payment.paymentStatus != PaymentStatus.VERIFYING) {
            throw BusinessException("PAYMENT-005", "Payment is not in VERIFYING state")
        }

        // Update Payment
        payment.paymentStatus = PaymentStatus.REJECTED
        payment.rejectionReason = request.reason
        payment.verifiedBy = admin
        payment.verifiedAt = OffsetDateTime.now()
        val savedPayment = paymentRepository.save(payment)

        // Update Order
        val order = payment.order!!
        order.status = OrderStatus.PAYMENT_REJECTED
        orderRepository.save(order)

        // Return Reserved Stock
        val orderItems = orderItemRepository.findByOrderId(order.id!!)
        for (item in orderItems) {
            val inventory = inventoryRepository.findByProductIdForUpdate(item.product!!.id!!)
                ?: throw BusinessException("ORDER-003", "Inventory record missing")
            
            inventory.reservedStock -= item.quantity
            inventoryRepository.save(inventory)
        }

        // Audit Log Event
        eventPublisher.publishEvent(
            AuditEvent(
                actorId = adminId,
                action = "REJECT_PAYMENT",
                resource = "payments",
                entityId = paymentId,
                oldValue = "VERIFYING",
                newValue = "REJECTED",
                ipAddress = null,
                device = null
            )
        )

        return paymentMapper.toResponseDto(savedPayment)
    }
}
