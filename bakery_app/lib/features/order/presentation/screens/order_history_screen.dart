import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_history_controller.dart';
import '../../data/models/order_model.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends GetView<OrderHistoryController> {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A1A)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: controller.obx(
        (orders) {
          return ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(24.0),
            itemCount: orders!.length + (controller.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == orders.length) {
                return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator(color: Color(0xFFFF9800))));
              }
              final order = orders[index];
              return _buildOrderCard(order);
            },
          );
        },
        onLoading: const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800))),
        onEmpty: const Center(
          child: Text(
            'Belum ada pesanan.',
            style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
          ),
        ),
        onError: (error) => Center(
          child: Text(
            'Gagal: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final dateObj = DateTime.tryParse(order.orderedAt)?.toLocal();
    final dateStr = dateObj != null ? DateFormat('dd MMM yyyy, HH:mm').format(dateObj) : order.orderedAt;

    Color statusColor;
    switch (order.status) {
      case 'WAITING_PAYMENT':
      case 'PENDING':
        statusColor = const Color(0xFFFF9800);
        break;
      case 'VERIFYING_PAYMENT':
      case 'PROCESSING':
        statusColor = Colors.blue;
        break;
      case 'COMPLETED':
        statusColor = Colors.green;
        break;
      case 'CANCELLED':
      case 'PAYMENT_REJECTED':
      case 'EXPIRED':
        statusColor = Colors.red;
        break;
      default:
        statusColor = const Color(0xFF757575);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'ID Pesanan: ${order.id.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.readableStatus,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tanggal',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                ),
              ),
              Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Harga',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                ),
              ),
              Text(
                'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(order.totalAmount)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFF9800),
                ),
              ),
            ],
          ),
          if (order.items.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Daftar Barang:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 8),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.productName}', 
                          style: const TextStyle(fontSize: 14, color: Color(0xFF424242)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format((item.priceAtPurchase * item.quantity))}', 
                        style: const TextStyle(fontSize: 14, color: Color(0xFF424242))
                      ),
                    ],
                  ),
                )),
          ],
          if (order.status == 'WAITING_PAYMENT' || order.status == 'PENDING' || order.status == 'PAYMENT_REJECTED') ...[
            const SizedBox(height: 16),
            if (order.status == 'PAYMENT_REJECTED' && order.rejectionReason != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Alasan Penolakan: ${order.rejectionReason}',
                        style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/payment', arguments: order),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Bayar Sekarang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
