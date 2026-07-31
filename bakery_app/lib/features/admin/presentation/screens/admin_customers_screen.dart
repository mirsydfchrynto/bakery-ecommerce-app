import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/admin_customers_controller.dart';
import '../widgets/admin_drawer.dart';
import '../../data/models/user_model.dart';

class AdminCustomersScreen extends GetView<AdminCustomersController> {
  const AdminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      drawer: const AdminDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1F2937)),
        title: const Text(
          'Kelola Pengguna',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              children: [
                _buildMetrics(),
                const SizedBox(height: 20),
                _buildSearchBar(),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => controller.fetchCustomers(),
              color: const Color(0xFFFF9800),
              child: controller.obx(
                (customers) {
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                    itemCount: customers!.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return _buildCustomerCard(customer);
                    },
                  );
                },
                onLoading: const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800))),
                onEmpty: _buildEmptyState(),
                onError: (error) => _buildErrorState(error.toString()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics() {
    return Obx(() {
      final total = controller.allCustomers.length;
      final admins = controller.allCustomers.where((u) => u.role == 'ADMIN').length;
      final customers = controller.allCustomers.where((u) => u.role == 'CUSTOMER').length;

      return Row(
        children: [
          Expanded(child: _buildMetricCard('Total\nPengguna', total.toString(), Icons.people, const Color(0xFF3B82F6))),
          const SizedBox(width: 12),
          Expanded(child: _buildMetricCard('Admin', admins.toString(), Icons.admin_panel_settings, const Color(0xFF8B5CF6))),
          const SizedBox(width: 12),
          Expanded(child: _buildMetricCard('Pelanggan', customers.toString(), Icons.shopping_bag, const Color(0xFF10B981))),
        ],
      );
    });
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color.withValues(alpha: 0.8), height: 1.1),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: controller.searchController,
      onChanged: controller.onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Cari nama, email, atau role...',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  controller.searchController.clear();
                  controller.onSearchChanged('');
                },
              )
            : const SizedBox.shrink()),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFF9800)),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Tidak ada pengguna ditemukan.',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text('Gagal memuat data:\n$error', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.fetchCustomers(),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9800)),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(UserModel customer) {
    final isAdmin = customer.role == 'ADMIN';
    final roleColor = isAdmin ? const Color(0xFF3B82F6) : const Color(0xFF10B981);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: roleColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: (customer.displayProfileImageUrl != null)
                ? CachedNetworkImage(
                    imageUrl: customer.displayProfileImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[200]!,
                      highlightColor: Colors.grey[50]!,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(isAdmin ? Icons.admin_panel_settings : Icons.person, color: roleColor, size: 28),
                  )
                : Icon(isAdmin ? Icons.admin_panel_settings : Icons.person, color: roleColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        customer.username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        customer.role,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: roleColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.email_outlined, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        customer.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
              onPressed: () {
                if (customer.username == 'irsyad') {
                  Get.snackbar('Ditolak', 'Tidak dapat menghapus super-admin utama!', 
                    backgroundColor: Colors.orange, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
                  return;
                }
                
                Get.defaultDialog(
                  title: 'Hapus Pengguna',
                  titlePadding: const EdgeInsets.only(top: 24, bottom: 8),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  content: Text(
                    'Apakah Anda yakin ingin menghapus akun\n"${customer.username}"?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF4B5563)),
                  ),
                  confirm: ElevatedButton(
                    onPressed: () {
                      controller.deleteCustomer(customer.id);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  cancel: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                  radius: 20,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
