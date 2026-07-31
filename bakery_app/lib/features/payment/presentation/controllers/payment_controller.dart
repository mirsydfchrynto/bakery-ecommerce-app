import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/datasource/payment_remote_data_source.dart';

class PaymentController extends GetxController {
  final PaymentRemoteDataSource remoteDataSource;
  PaymentController(this.remoteDataSource);

  final selectedImages = <XFile>[].obs;
  final isLoading = false.obs;
  
  final ImagePicker _picker = ImagePicker();

  void pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      if (images.length > 5) {
        Get.snackbar('Gagal', 'Maksimal 5 gambar diperbolehkan');
        selectedImages.value = images.take(5).toList();
      } else {
        selectedImages.value = images;
      }
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> submitPayment(dynamic order) async {
    if (selectedImages.isEmpty) {
      Get.snackbar('Gagal', 'Minimal 1 screenshot diperlukan');
      return;
    }
    
    isLoading.value = true;
    try {
      // For simplicity, just uploading the first image to the endpoint 
      // since the current remoteDataSource accepts single filePath.
      // Wait, we need it to accept multiple files! We can update RemoteDataSource to accept List<String>.
      await remoteDataSource.uploadPaymentProof(
        orderId: order['orderId'],
        paymentMethod: 'BCA Transfer',
        bankName: 'BCA',
        accountName: 'Bakery Shop',
        transferAmount: (order['totalAmount'] as num).toDouble(),
        filePaths: selectedImages.map((e) => e.path).toList(),
      );
      
      Get.snackbar('Berhasil', 'Bukti pembayaran diunggah! Menunggu verifikasi.');
      Get.offNamedUntil('/home', (route) => false);
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal mengunggah: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleBackPress(String orderId) async {
    // Tampilkan dialog konfirmasi pembatalan
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Batalkan Pembayaran?'),
        content: const Text('Jika Anda kembali sekarang, pesanan Anda akan dibatalkan dan keranjang akan direset. Apakah Anda yakin?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Tidak, lanjutkan pembayaran'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Ya, batalkan pesanan', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (result == true) {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      try {
        await remoteDataSource.cancelOrder(orderId);
        Get.back(); // tutup loading
        Get.offAllNamed('/home'); // arahkan ke home
        Get.snackbar('Dibatalkan', 'Pesanan Anda telah dibatalkan dan keranjang direset.', 
            backgroundColor: const Color(0xFFF44336), colorText: Colors.white);
      } catch (e) {
        Get.back(); // tutup loading
        Get.snackbar('Gagal', 'Gagal membatalkan pesanan: $e');
      }
    }
  }
}
