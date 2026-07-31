import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../widgets/admin_drawer.dart';

class AdminDashboardScreen extends GetView<AdminDashboardController> {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      drawer: const AdminDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dasbor Analitik',
          style: TextStyle(color: Color(0xFF1F2937), fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF4B5563)),
            onPressed: () => controller.fetchDashboardData(),
          ),
        ],
      ),
      body: controller.obx(
        (data) {
          final totalRevenue = data!['totalRevenue'] as num;
          final totalOrders = data['totalOrders'] as num;
          final ordersByStatus = data['ordersByStatus'] as Map<String, dynamic>;
          final topProducts = data['topProducts'] as List<dynamic>;

          return RefreshIndicator(
            onRefresh: () => controller.fetchDashboardData(),
            color: const Color(0xFFFF9800),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 24),
                  _buildSummaryCards(totalRevenue, totalOrders),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Pesanan Berdasarkan Status', Icons.pie_chart_outline),
                  const SizedBox(height: 16),
                  _buildStatusCards(ordersByStatus),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Produk Terlaris', Icons.star_border_outlined),
                  const SizedBox(height: 16),
                  _buildTopProducts(topProducts),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
        onLoading: const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800))),
        onError: (err) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Gagal memuat data:\n$err', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.fetchDashboardData(),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Bisnis',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF111827), letterSpacing: -0.5),
        ),
        const SizedBox(height: 4),
        Text(
          'Pantau performa toko Anda hari ini',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 22, color: const Color(0xFF4B5563)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827), letterSpacing: -0.5),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(num totalRevenue, num totalOrders) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        if (isWide) {
          return Row(
            children: [
              Expanded(child: _buildSummaryCard('Total Pendapatan', 'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(totalRevenue)}', Icons.account_balance_wallet, const Color(0xFFF59E0B), const Color(0xFFFEF3C7))),
              const SizedBox(width: 16),
              Expanded(child: _buildSummaryCard('Total Pesanan', totalOrders.toString(), Icons.shopping_bag, const Color(0xFF10B981), const Color(0xFFD1FAE5))),
            ],
          );
        }
        return Column(
          children: [
            _buildSummaryCard('Total Pendapatan', 'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(totalRevenue)}', Icons.account_balance_wallet, const Color(0xFFF59E0B), const Color(0xFFFEF3C7)),
            const SizedBox(height: 16),
            _buildSummaryCard('Total Pesanan', totalOrders.toString(), Icons.shopping_bag, const Color(0xFF10B981), const Color(0xFFD1FAE5)),
          ],
        );
      }
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 15, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF111827), letterSpacing: -0.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'WAITING_PAYMENT': return 'Menunggu\nPembayaran';
      case 'PAID': return 'Dibayar';
      case 'PREPARING': return 'Disiapkan';
      case 'READY_FOR_PICKUP': return 'Siap Diambil';
      case 'COMPLETED': return 'Selesai';
      case 'CANCELLED': return 'Dibatalkan';
      default: return status.replaceAll('_', ' ');
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'WAITING_PAYMENT': return Icons.hourglass_empty;
      case 'PAID': return Icons.payment;
      case 'PREPARING': return Icons.soup_kitchen;
      case 'READY_FOR_PICKUP': return Icons.local_mall;
      case 'COMPLETED': return Icons.check_circle;
      case 'CANCELLED': return Icons.cancel;
      default: return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'WAITING_PAYMENT': return const Color(0xFFF59E0B);
      case 'PAID': return const Color(0xFF3B82F6);
      case 'PREPARING': return const Color(0xFF8B5CF6);
      case 'READY_FOR_PICKUP': return const Color(0xFF10B981);
      case 'COMPLETED': return const Color(0xFF059669);
      case 'CANCELLED': return const Color(0xFFEF4444);
      default: return const Color(0xFF6B7280);
    }
  }

  Widget _buildStatusCards(Map<String, dynamic> statusMap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 600) crossAxisCount = 4;
        if (constraints.maxWidth > 900) crossAxisCount = 6;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: statusMap.length,
          itemBuilder: (context, index) {
            final entry = statusMap.entries.elementAt(index);
            final color = _getStatusColor(entry.key);
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: Icon(_getStatusIcon(entry.key), color: color, size: 20),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.value}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _translateStatus(entry.key),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade600, height: 1.1),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }

  Widget _buildTopProducts(List<dynamic> products) {
    if (products.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('Belum ada data penjualan produk', style: TextStyle(color: Colors.grey.shade500)),
          ],
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 4)),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products.length,
        separatorBuilder: (c, i) => Divider(height: 1, color: Colors.grey.shade100, indent: 64),
        itemBuilder: (context, index) {
          final prod = products[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: index == 0 ? const Color(0xFFFEF3C7) : 
                       index == 1 ? const Color(0xFFF3F4F6) : 
                       index == 2 ? const Color(0xFFFFF7ED) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: index == 0 ? const Color(0xFFD97706) : 
                           index == 1 ? const Color(0xFF4B5563) : 
                           index == 2 ? const Color(0xFFC2410C) : Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            title: Text(prod['productName'], style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Terjual ${prod['quantitySold']}',
                style: const TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
