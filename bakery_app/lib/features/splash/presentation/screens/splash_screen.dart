import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../../../core/storage/secure_storage_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic)),
    );

    _controller.forward();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    final storage = Get.find<SecureStorageHelper>();
    final token = await storage.getToken();
    final role = await storage.getRole();

    if (token != null && token.isNotEmpty) {
      if (role == 'ADMIN') {
        Get.offAllNamed(Routes.adminHome);
      } else {
        Get.offAllNamed(Routes.home);
      }
    } else {
      Get.offAllNamed(Routes.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Premium Dark
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with dark overlay
          CachedNetworkImage(
            imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=1200&auto=format&fit=crop',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: const Color(0xFF0A0A0A)),
            errorWidget: (context, url, error) => Container(color: const Color(0xFF0A0A0A)),
          ),
          Container(
            color: const Color(0xFF0A0A0A).withValues(alpha: 0.8), // Dark tint
          ),
          
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'BAKERY',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 12.0,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'ARTISAN BREADS & PASTRIES',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFD4D4D4),
                        letterSpacing: 4.0,
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
}
