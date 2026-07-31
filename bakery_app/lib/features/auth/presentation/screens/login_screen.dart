import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/widget/primary_button.dart';
import '../../../../core/widget/bakery_text_field.dart';
import '../../../../routes/app_pages.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController controller = Get.find<AuthController>();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aesthetic Header Image
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: 'https://images.unsplash.com/photo-1549931319-a545dcf3bc73?q=80&w=1000&auto=format&fit=crop',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey[200]),
                    errorWidget: (context, url, error) => Container(color: Colors.grey[200]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.2),
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat\nDatang.',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A1A),
                      height: 1.1,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Masuk untuk mengakses akun Anda.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  BakeryTextField(
                    label: 'Email, Nama Pengguna, atau Telepon',
                    hint: 'Masukkan identitas Anda',
                    prefixIcon: Icons.person_outline_rounded,
                    controller: usernameCtrl,
                  ),
                  const SizedBox(height: 24),
                  BakeryTextField(
                    label: 'Password',
                    hint: 'Masukkan password Anda',
                    prefixIcon: Icons.lock_outline_rounded,
                    isPassword: true,
                    controller: passwordCtrl,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.toNamed(Routes.forgotPassword),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Lupa Password?',
                        style: TextStyle(
                          color: Color(0xFFFF9800),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  

                  
                  controller.obx(
                    (state) => PrimaryButton(
                      text: 'Masuk',
                      onPressed: () {
                        if (usernameCtrl.text.trim().isEmpty || passwordCtrl.text.isEmpty) {
                          Get.snackbar('Gagal', 'Identitas dan Password tidak boleh kosong', backgroundColor: Colors.redAccent, colorText: Colors.white);
                          return;
                        }
                        controller.login(usernameCtrl.text.trim(), passwordCtrl.text);
                      },
                    ),
                    onLoading: PrimaryButton(
                      text: 'Masuk',
                      isLoading: true,
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(color: Color(0xFF757575)),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.register),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Daftar sekarang',
                          style: TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
