import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../order/presentation/controllers/cart_controller.dart';
import '../controllers/main_screen_controller.dart';

import 'home_screen.dart';
import 'menu_screen.dart';
import '../../../order/presentation/screens/cart_screen.dart';
import '../../../auth/presentation/screens/profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainScreenController());

    final List<Widget> pages = [
      const HomeScreen(),
      const MenuScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: pages,
      )),
      floatingActionButton: Obx(() {
        if (controller.currentIndex.value == 2) return const SizedBox.shrink();
        final cartController = Get.find<CartController>();
        final cartCount = cartController.itemCount;
        if (cartCount == 0) return const SizedBox.shrink();
        
        return FloatingActionButton.extended(
          onPressed: () => controller.changeTab(2),
          backgroundColor: const Color(0xFFFF9800),
          icon: const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.white),
          label: Text('Keranjang ($cartCount)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.currentIndex.value == 2) {
          return const SizedBox.shrink();
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(controller, Icons.home_rounded, 'Beranda', 0),
                  _buildNavItem(controller, Icons.menu_book_rounded, 'Menu', 1),
                  _buildNavItem(controller, Icons.shopping_bag_outlined, 'Keranjang', 2),
                  _buildNavItem(controller, Icons.person_outline_rounded, 'Profil', 3),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNavItem(MainScreenController controller, IconData icon, String label, int index) {
    final isSelected = controller.currentIndex.value == index;
    final color = isSelected ? const Color(0xFFFF9800) : const Color(0xFFBDBDBD);
    
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF9800).withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
