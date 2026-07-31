import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../../../core/storage/secure_storage_helper.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String _username = 'Admin';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final storage = Get.find<SecureStorageHelper>();
    final savedName = await storage.getUsername() ?? 'Admin';
    if (mounted) {
      setState(() {
        _username = savedName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Light background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        title: const Text(
          'Konsol Admin',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFE53935)), // Red for logout
            onPressed: () async {
              final storage = Get.find<SecureStorageHelper>();
              await storage.clearAll();
              Get.offAllNamed(Routes.login);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selamat Datang,\n$_username!',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kelola pesanan pelanggan, stok katalog, dan akun pengguna dengan mudah.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 48),
            _buildAdminMenu(
              context,
              icon: Icons.list_alt_rounded,
              title: 'Kelola Pesanan',
              subtitle: 'Verifikasi pembayaran dan perbarui status',
              gradientColors: [const Color(0xFFFF9800), const Color(0xFFF57C00)], // Orange
              onTap: () {
                Get.toNamed(Routes.adminOrders);
              },
            ),
            const SizedBox(height: 24),
            _buildAdminMenu(
              context,
              icon: Icons.inventory_2_outlined,
              title: 'Kelola Katalog',
              subtitle: 'Tambah, edit, atau hapus produk & stok',
              gradientColors: [const Color(0xFFFFB74D), const Color(0xFFFF9800)],
              onTap: () {
                Get.toNamed(Routes.adminProducts);
              },
            ),
            const SizedBox(height: 24),
            _buildAdminMenu(
              context,
              icon: Icons.people_alt_outlined,
              title: 'Kelola Pelanggan',
              subtitle: 'Lihat dan kelola akun pelanggan',
              gradientColors: [const Color(0xFFFFCC80), const Color(0xFFFFA726)],
              onTap: () {
                Get.toNamed('/admin-customers');
              },
            ),
            const SizedBox(height: 24),
            _buildAdminMenu(
              context,
              icon: Icons.analytics_outlined,
              title: 'Dasbor Analitik',
              subtitle: 'Lihat statistik pendapatan dan penjualan',
              gradientColors: [const Color(0xFF4CAF50), const Color(0xFF388E3C)],
              onTap: () {
                Get.toNamed('/admin-dashboard');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminMenu(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
