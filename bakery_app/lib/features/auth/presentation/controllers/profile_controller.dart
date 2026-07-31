import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../routes/app_pages.dart';

class ProfileController extends GetxController with StateMixin<Map<String, dynamic>> {
  final AuthRepository repository;

  ProfileController(this.repository);

  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  
  final oldPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void fetchProfile() async {
    change(null, status: RxStatus.loading());
    try {
      final data = await repository.getProfile();
      usernameCtrl.text = data['username'] ?? '';
      emailCtrl.text = data['email'] ?? '';
      phoneCtrl.text = data['phoneNumber'] ?? '';
      change(data, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> updateProfile() async {
    if (usernameCtrl.text.isEmpty || emailCtrl.text.isEmpty || phoneCtrl.text.isEmpty) {
      Get.snackbar('Gagal', 'Kolom tidak boleh kosong', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      final updatedData = await repository.updateProfile(usernameCtrl.text, emailCtrl.text, phoneCtrl.text);
      Get.back(); // close dialog
      change(updatedData, status: RxStatus.success());
      Get.back(); // close edit sheet/dialog
      Get.snackbar('Berhasil', 'Profil berhasil diperbarui', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.back(); // close dialog
      Get.snackbar('Gagal', e.toString(), backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  Future<void> changePassword() async {
    if (oldPasswordCtrl.text.isEmpty || newPasswordCtrl.text.isEmpty) {
      Get.snackbar('Gagal', 'Password tidak boleh kosong', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await repository.changePassword(oldPasswordCtrl.text, newPasswordCtrl.text);
      Get.back();
      Get.back(); // close dialog
      oldPasswordCtrl.clear();
      newPasswordCtrl.clear();
      Get.snackbar('Berhasil', 'Password berhasil diubah', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.back();
      Get.snackbar('Gagal', e.toString(), backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  Future<void> deleteAccount() async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      await repository.deleteAccount();
      Get.back();
      Get.offAllNamed(Routes.login);
      Get.snackbar('Berhasil', 'Akun berhasil dihapus', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.back();
      Get.snackbar('Gagal', e.toString(), backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  Future<void> pickImageAndUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      try {
        Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
        // Upload image first
        final imageUrl = await repository.uploadProfilePicture(pickedFile.path);
        
        // Then update profile
        final updatedData = await repository.updateProfile(
          usernameCtrl.text,
          emailCtrl.text,
          phoneCtrl.text,
          profilePictureUrl: imageUrl,
        );
        
        Get.back();
        change(updatedData, status: RxStatus.success());
        Get.snackbar('Berhasil', 'Foto profil diperbarui', backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
        Get.back();
        Get.snackbar('Gagal', 'Gagal mengunggah gambar: ${e.toString()}', backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    }
  }
}
