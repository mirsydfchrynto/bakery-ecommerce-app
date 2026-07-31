import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';
import '../../../../core/widget/bakery_text_field.dart';
import '../../../../core/widget/primary_button.dart';
import '../../../admin/data/models/user_model.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: controller.obx(
        (data) {
          final user = UserModel.fromJson(data!);
          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              const Text(
                'Profil',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: controller.pickImageAndUpload,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFFF9800), width: 3),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: (user.displayProfileImageUrl != null)
                                ? CachedNetworkImage(
                                    imageUrl: user.displayProfileImageUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(color: Colors.white),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.network('https://ui-avatars.com/api/?name=${user.username}&background=FF9800&color=fff&size=200'),
                                  )
                                : Image.network('https://ui-avatars.com/api/?name=${user.username}&background=FF9800&color=fff&size=200'),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF9800),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.username,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              _buildProfileMenu(Icons.person_outline_rounded, 'Edit Profil', () {
                _showEditProfileSheet(context);
              }),
              const SizedBox(height: 16),
              _buildProfileMenu(Icons.lock_outline_rounded, 'Ganti Password', () {
                _showChangePasswordSheet(context);
              }),
              const SizedBox(height: 16),
              _buildProfileMenu(Icons.shopping_bag_outlined, 'Pesanan Saya', () {
                Get.toNamed(Routes.orderHistory);
              }),
              const SizedBox(height: 48),
              _buildProfileMenu(Icons.logout_rounded, 'Keluar', () {
                controller.repository.logout().then((_) => Get.offAllNamed(Routes.login));
              }, isDestructive: true),
              const SizedBox(height: 16),
              _buildProfileMenu(Icons.delete_forever_rounded, 'Hapus Akun', () {
                _showDeleteConfirmation(context);
              }, isDestructive: true),
              const SizedBox(height: 40),
            ],
          );
        },
        onLoading: const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800))),
        onError: (error) => Center(child: Text('Error: $error')),
      ),
    ));
  }

  void _showEditProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Edit Profil', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            BakeryTextField(label: 'Nama Pengguna', hint: 'Nama Pengguna', prefixIcon: Icons.person, controller: controller.usernameCtrl),
            const SizedBox(height: 16),
            BakeryTextField(label: 'Email', hint: 'Email', prefixIcon: Icons.email, controller: controller.emailCtrl),
            const SizedBox(height: 16),
            BakeryTextField(label: 'Telepon', hint: 'Nomor Telepon', prefixIcon: Icons.phone, controller: controller.phoneCtrl),
            const SizedBox(height: 32),
            PrimaryButton(text: 'Simpan Perubahan', onPressed: controller.updateProfile),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ganti Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            BakeryTextField(label: 'Password Lama', hint: 'Masukkan password lama', prefixIcon: Icons.lock, isPassword: true, controller: controller.oldPasswordCtrl),
            const SizedBox(height: 16),
            BakeryTextField(label: 'Password Baru', hint: 'Masukkan password baru', prefixIcon: Icons.lock_outline, isPassword: true, controller: controller.newPasswordCtrl),
            const SizedBox(height: 32),
            PrimaryButton(text: 'Perbarui Password', onPressed: controller.changePassword),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.defaultDialog(
      title: 'Hapus Akun',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      content: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Apakah Anda yakin ingin menghapus akun? Tindakan ini tidak dapat dibatalkan.', textAlign: TextAlign.center),
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: controller.deleteAccount,
        child: const Text('Hapus', style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Batal', style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildProfileMenu(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.red : const Color(0xFF1A1A1A);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withValues(alpha: 0.1) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
      trailing: isDestructive ? null : const Icon(Icons.chevron_right_rounded, color: Color(0xFFBDBDBD)),
      onTap: onTap,
    );
  }
}
