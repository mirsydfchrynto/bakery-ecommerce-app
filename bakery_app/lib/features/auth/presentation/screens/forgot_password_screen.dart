import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';
import '../../../../core/widget/bakery_text_field.dart';
import '../../../../core/widget/primary_button.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lupa Password',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Masukkan alamat email Anda. Kami akan mengirimkan OTP untuk mengatur ulang password Anda.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF757575),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              BakeryTextField(
                controller: controller.emailCtrl,
                label: 'Email',
                hint: 'Masukkan email Anda',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Kirim OTP',
                onPressed: controller.sendOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
