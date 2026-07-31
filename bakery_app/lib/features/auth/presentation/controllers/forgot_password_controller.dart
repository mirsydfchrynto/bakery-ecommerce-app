import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository repository;

  ForgotPasswordController(this.repository);

  final emailCtrl = TextEditingController();
  final tokenCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();

  Future<void> sendOtp() async {
    if (emailCtrl.text.isEmpty) {
      Get.snackbar('Gagal', 'Email wajib diisi', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await repository.forgotPassword(emailCtrl.text);
      Get.back();
      Get.toNamed(Routes.resetPassword);
      Get.snackbar('OTP Terkirim', 'Periksa email atau konsol Anda untuk OTP.', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.back();
      Get.snackbar('Gagal', e.toString(), backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  Future<void> resetPassword() async {
    if (tokenCtrl.text.isEmpty || newPasswordCtrl.text.isEmpty) {
      Get.snackbar('Gagal', 'OTP dan password baru wajib diisi', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await repository.resetPassword(tokenCtrl.text, newPasswordCtrl.text);
      Get.back();
      Get.offAllNamed(Routes.login);
      Get.snackbar('Berhasil', 'Password telah diatur ulang. Silakan masuk.', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.back();
      Get.snackbar('Gagal', e.toString(), backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
}
