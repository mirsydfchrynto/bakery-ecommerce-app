import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../core/storage/secure_storage_helper.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFF9800), // Orange theme
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront_rounded, size: 48, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'Bakery Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home_rounded,
            title: 'Beranda Utama',
            isSelected: currentRoute == Routes.adminHome,
            onTap: () {
              Get.back();
              if (currentRoute != Routes.adminHome) {
                Get.offNamed(Routes.adminHome);
              }
            },
          ),
          _buildDrawerItem(
            icon: Icons.dashboard_rounded,
            title: 'Dasbor Analitik',
            isSelected: currentRoute == Routes.adminDashboard,
            onTap: () {
              Get.back(); // close drawer
              if (currentRoute != Routes.adminDashboard) {
                Get.offNamed(Routes.adminDashboard);
              }
            },
          ),
          _buildDrawerItem(
            icon: Icons.receipt_long_rounded,
            title: 'Kelola Pesanan',
            isSelected: currentRoute == Routes.adminOrders,
            onTap: () {
              Get.back();
              if (currentRoute != Routes.adminOrders) {
                Get.offNamed(Routes.adminOrders);
              }
            },
          ),
          _buildDrawerItem(
            icon: Icons.inventory_2_outlined,
            title: 'Kelola Katalog',
            isSelected: currentRoute == Routes.adminProducts,
            onTap: () {
              Get.back();
              if (currentRoute != Routes.adminProducts) {
                Get.offNamed(Routes.adminProducts);
              }
            },
          ),
          _buildDrawerItem(
            icon: Icons.people_alt_outlined,
            title: 'Kelola Pelanggan',
            isSelected: currentRoute == Routes.adminCustomers,
            onTap: () {
              Get.back();
              if (currentRoute != Routes.adminCustomers) {
                Get.offNamed(Routes.adminCustomers);
              }
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () async {
              final storage = Get.find<SecureStorageHelper>();
              await storage.clearAll();
              Get.offAllNamed(Routes.login);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      tileColor: isSelected ? const Color(0xFFFF9800).withValues(alpha: 0.1) : Colors.transparent,
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFFFF9800) : Colors.black54,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFFFF9800) : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }
}
