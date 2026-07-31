import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';
import '../../../../core/widget/bakery_text_field.dart';
import '../../../../core/widget/primary_button.dart';

class ResetPasswordScreen extends GetView<ForgotPasswordController> {
  const ResetPasswordScreen({super.key});

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
                'Reset Password',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Masukkan OTP yang Anda terima beserta password baru.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF757575),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              BakeryTextField(
                controller: controller.tokenCtrl,
                label: 'OTP / Token',
                hint: 'Masukkan 6 digit OTP',
                prefixIcon: Icons.key_outlined,
              ),
              const SizedBox(height: 16),
              BakeryTextField(
                controller: controller.newPasswordCtrl,
                label: 'Password Baru',
                hint: 'Masukkan password baru Anda',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Atur Ulang Password',
                onPressed: controller.resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
