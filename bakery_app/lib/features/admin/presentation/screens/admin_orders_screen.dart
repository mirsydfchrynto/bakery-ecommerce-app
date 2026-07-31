import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_orders_controller.dart';
import '../../../order/data/models/order_model.dart';
import 'package:intl/intl.dart';
import '../widgets/admin_drawer.dart';

class AdminOrdersScreen extends GetView<AdminOrdersController> {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      drawer: const AdminDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        title: const Text(
          'Kelola Pesanan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Chips
          Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('PENDING'),
                const SizedBox(width: 8),
                _buildFilterChip('VERIFYING_PAYMENT'),
                const SizedBox(width: 8),
                _buildFilterChip('PROCESSING'),
                const SizedBox(width: 8),
                _buildFilterChip('COMPLETED'),
                const SizedBox(width: 8),
                _buildFilterChip('CANCELLED'),
              ],
            ),
          )),
          
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.fetchOrders,
              color: const Color(0xFFFF9800),
              child: controller.obx(
                (orders) {
                  return ListView.builder(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
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
                onEmpty: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 100),
                    Center(
                      child: Text(
                        'Tidak ada pesanan untuk status ini.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                onError: (error) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 100),
                    Center(
                      child: Text(
                        'Gagal: $error',
                        style: const TextStyle(color: Color(0xFFE53935)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getReadableStatus(String status) {
    switch (status) {
      case 'All': return 'Semua Pesanan';
      case 'DRAFT': return 'Draf';
      case 'PENDING': return 'Menunggu Checkout';
      case 'WAITING_PAYMENT': return 'Menunggu Pembayaran';
      case 'VERIFYING_PAYMENT': return 'Perlu Validasi';
      case 'PROCESSING': return 'Diproses Dapur';
      case 'COMPLETED': return 'Selesai';
      case 'PAYMENT_REJECTED': return 'Pembayaran Ditolak';
      case 'CANCELLED': return 'Dibatalkan';
      case 'EXPIRED': return 'Kadaluarsa';
      default: return status.replaceAll('_', ' ');
    }
  }

  Widget _buildFilterChip(String status) {
    final isSelected = controller.selectedStatus.value == status;
    return ChoiceChip(
      label: Text(_getReadableStatus(status)),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) controller.changeFilter(status);
      },
      selectedColor: const Color(0xFFFF9800).withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFFFF9800) : Colors.black54,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? const Color(0xFFFF9800) : Colors.grey.shade300,
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
        statusColor = const Color(0xFFF57C00);
        break;
      case 'PROCESSING':
      case 'VERIFYING_PAYMENT':
        statusColor = const Color(0xFF1E88E5);
        break;
      case 'COMPLETED':
        statusColor = const Color(0xFF43A047);
        break;
      case 'CANCELLED':
      case 'PAYMENT_REJECTED':
      case 'EXPIRED':
        statusColor = const Color(0xFFE53935);
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      'ID: ${order.id.substring(0, 8).toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    if (order.customerName != null && order.customerName!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.person_rounded, size: 14, color: Colors.black54),
                            const SizedBox(width: 4),
                            SelectableText(
                              order.customerName!,
                              style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    if (order.customerPhone != null && order.customerPhone!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.phone_rounded, size: 14, color: Colors.black54),
                            const SizedBox(width: 4),
                            SelectableText(
                              order.customerPhone!,
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
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
              const Text('Tanggal', style: TextStyle(fontSize: 14, color: Colors.black54)),
              Text(dateStr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Harga', style: TextStyle(fontSize: 14, color: Colors.black54)),
              Text('Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(order.totalAmount)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFFFF9800))),
            ],
          ),
          if (order.items.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('Barang:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
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
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format((item.priceAtPurchase * item.quantity))}', 
                        style: const TextStyle(fontSize: 14, color: Colors.black54)
                      ),
                    ],
                  ),
                )),
          ],
          
          if (order.status == 'VERIFYING_PAYMENT') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.viewPaymentProof(order.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Lihat Bukti Bayar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFEEEEEE)),
          const SizedBox(height: 8),
          const Text(
            'Ubah Status:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _statusButton('PROCESSING', const Color(0xFF1E88E5), order.id),
                const SizedBox(width: 8),
                _statusButton('COMPLETED', const Color(0xFF43A047), order.id),
                const SizedBox(width: 8),
                _statusButton('CANCELLED', const Color(0xFFE53935), order.id),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statusButton(String status, Color color, String orderId) {
    return ActionChip(
      label: Text(_getReadableStatus(status)),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      backgroundColor: color.withValues(alpha: 0.05),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        Get.defaultDialog(
          title: 'Ubah Status',
          middleText: 'Apakah Anda yakin ingin mengubah pesanan ini menjadi ${_getReadableStatus(status)}?',
          textConfirm: 'Ya',
          textCancel: 'Batal',
          confirmTextColor: Colors.white,
          buttonColor: color,
          onConfirm: () {
            Get.back(); // Close dialog
            controller.updateStatus(orderId, status);
          },
        );
      },
    );
  }
}
