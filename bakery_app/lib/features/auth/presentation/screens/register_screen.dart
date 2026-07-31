import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/widget/primary_button.dart';
import '../../../../core/widget/bakery_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController controller = Get.find<AuthController>();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  void _handleRegister() {
    if (usernameCtrl.text.isEmpty || emailCtrl.text.isEmpty || phoneCtrl.text.isEmpty || passwordCtrl.text.isEmpty || confirmPasswordCtrl.text.isEmpty) {
      Get.snackbar('Gagal', 'Semua kolom wajib diisi', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    
    if (!GetUtils.isEmail(emailCtrl.text)) {
      Get.snackbar('Gagal', 'Format email tidak valid', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    
    if (!GetUtils.isPhoneNumber(phoneCtrl.text) || phoneCtrl.text.length < 10) {
      Get.snackbar('Gagal', 'Format nomor telepon tidak valid', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    
    if (passwordCtrl.text.length < 8) {
      Get.snackbar('Gagal', 'Password minimal 8 karakter', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      Get.snackbar('Gagal', 'Password tidak cocok', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    
    controller.register(usernameCtrl.text, emailCtrl.text, phoneCtrl.text, passwordCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Daftar\nAkun Baru.',
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
              'Bergabunglah untuk mendapatkan pengalaman artisan bakery terbaik.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 48),
            
            BakeryTextField(
              label: 'Nama Pengguna',
              hint: 'Pilih nama pengguna',
              prefixIcon: Icons.person_outline_rounded,
              controller: usernameCtrl,
            ),
            const SizedBox(height: 20),
            
            BakeryTextField(
              label: 'Email',
              hint: 'Masukkan alamat email Anda',
              prefixIcon: Icons.email_outlined,
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            
            BakeryTextField(
              label: 'Nomor Telepon',
              hint: 'Masukkan nomor telepon Anda',
              prefixIcon: Icons.phone_outlined,
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            
            BakeryTextField(
              label: 'Password',
              hint: 'Buat password yang kuat',
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              controller: passwordCtrl,
            ),
            const SizedBox(height: 20),
            
            BakeryTextField(
              label: 'Konfirmasi Password',
              hint: 'Ulangi password Anda',
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              controller: confirmPasswordCtrl,
            ),
            const SizedBox(height: 48),
            
            controller.obx(
              (state) => PrimaryButton(
                text: 'Daftar',
                onPressed: _handleRegister,
              ),
              onLoading: PrimaryButton(
                text: 'Daftar',
                isLoading: true,
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 32),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sudah punya akun? ',
                  style: TextStyle(color: Color(0xFF757575)),
                ),
                TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Masuk',
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
    );
  }
}
