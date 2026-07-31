import 'dart:async';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../order/data/models/order_model.dart';
import '../../../order/domain/repository/order_repository.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../../core/constants/app_config.dart';

/// AdminOrdersController bertugas mengelola pesanan (Orders) bagi Admin.
/// Admin dapat melihat daftar pesanan, melihat bukti transfer, dan memvalidasi pembayaran.
class AdminOrdersController extends GetxController with StateMixin<List<OrderModel>> {
  final OrderRepository orderRepository;
  final AdminRepository adminRepository;

  AdminOrdersController(this.orderRepository, this.adminRepository);

  final ScrollController scrollController = ScrollController();
  int currentPage = 0;
  int totalPages = 1;
  bool isLoadingMore = false;
  List<OrderModel> orders = [];
  
  // Filter status ('All' by default)
  final RxString selectedStatus = 'All'.obs;

  // Real-time polling timer
  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    fetchOrders(); // Langsung ambil data pesanan saat halaman admin dibuka
    scrollController.addListener(_onScroll);
    
    // Mulai polling setiap 10 detik untuk real-time updates
    _startRealtimePolling();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    scrollController.dispose();
    super.onClose();
  }

  void _startRealtimePolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        final status = selectedStatus.value == 'All' ? null : selectedStatus.value;
        final result = await orderRepository.getAllOrders(page: 0, size: (currentPage + 1) * 10, status: status);
        final newOrders = result['content'] as List<OrderModel>;
        if (newOrders.isNotEmpty) {
          orders = newOrders;
          totalPages = result['totalPages'];
          update(); // Update UI
        }
      } catch (e) {
        // Abaikan error saat polling
      }
    });
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      loadMoreOrders();
    }
  }

  /// Mengambil daftar semua pesanan dari database via API.
  Future<void> fetchOrders() async {
    currentPage = 0;
    change(null, status: RxStatus.loading());
    try {
      final status = selectedStatus.value == 'All' ? null : selectedStatus.value;
      final result = await orderRepository.getAllOrders(page: currentPage, size: 10, status: status);
      orders = result['content'] as List<OrderModel>;
      totalPages = result['totalPages'];
      
      if (orders.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(orders, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void changeFilter(String status) {
    if (selectedStatus.value != status) {
      selectedStatus.value = status;
      fetchOrders();
    }
  }

  Future<void> loadMoreOrders() async {
    if (isLoadingMore || currentPage >= totalPages - 1) return;
    
    isLoadingMore = true;
    currentPage++;
    update();
    
    try {
      final status = selectedStatus.value == 'All' ? null : selectedStatus.value;
      final result = await orderRepository.getAllOrders(page: currentPage, size: 10, status: status);
      final newOrders = result['content'] as List<OrderModel>;
      totalPages = result['totalPages'];
      orders.addAll(newOrders);
      change(orders, status: RxStatus.success());
    } catch (e) {
      currentPage--;
      Get.snackbar('Gagal', 'Gagal memuat pesanan: ${e.toString()}');
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  /// Fungsi untuk mengubah status pesanan (Misal: dari PENDING menjadi PROCESSING/COMPLETED)
  Future<void> updateStatus(String orderId, String newStatus) async {
    try {
      await orderRepository.updateOrderStatus(orderId, newStatus);
      Get.snackbar('Berhasil', 'Status pesanan diubah ke $newStatus', 
        backgroundColor: Colors.green, colorText: Colors.white);
      fetchOrders(); // Refresh daftar setelah status berubah
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal mengubah status: $e');
    }
  }

  /// Memvalidasi dan menyetujui pembayaran secara resmi melalui Payment Service.
  /// Ini juga akan memotong inventory stock dan mencetak audit log.
  Future<void> approvePayment(String orderId) async {
    try {
      await adminRepository.approvePayment(orderId);
      Get.snackbar('Berhasil', 'Pembayaran disetujui dan stok dipotong', 
        backgroundColor: Colors.green, colorText: Colors.white);
      fetchOrders();
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal menyetujui pembayaran: $e',
        backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// Menolak pembayaran dan memberikan alasan
  Future<void> rejectPayment(String orderId, String reason) async {
    try {
      await adminRepository.rejectPayment(orderId, reason);
      Get.snackbar('Berhasil', 'Pembayaran ditolak', 
        backgroundColor: Colors.orange, colorText: Colors.white);
      fetchOrders();
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal menolak pembayaran: $e',
        backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  /// Membuka dialog untuk melihat bukti pembayaran yang diunggah pelanggan.
  Future<void> viewPaymentProof(String orderId) async {
    try {
      final data = await adminRepository.getPaymentDetails(orderId);
      
      // Backend mengembalikan URL gambar dalam format string JSON (contoh: "['/uploads/123.jpg']")
      final String urlsJson = data['paymentProofUrls'] ?? '[]';
      
      List<String> urls = [];
      try {
        // Parsing string JSON menjadi List murni Dart
        urls = List<String>.from(jsonDecode(urlsJson));
      } catch (e) {
        // Fallback manual jika parsing gagal
        if (urlsJson.startsWith('[')) {
          urls = urlsJson.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').split(',');
        }
      }
      
      urls.removeWhere((u) => u.trim().isEmpty);
      
      // 3. Ekstrak Base URL dari AppConfig untuk menghilangkan Magic Code
      // AppConfig.baseUrl bernilai 'http://10.0.2.2:8080/api/v1'. Kita hilangkan '/api/v1'-nya.
      final String hostUrl = AppConfig.baseUrl.replaceAll('/api/v1', '');
      
      // 4. Munculkan Dialog Pop-Up
      Get.dialog(
        AlertDialog(
          title: const Text('Bukti Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView(
              children: [
                Text('Bank: ${data['bankName']}', style: const TextStyle(fontSize: 16)),
                Text('Atas Nama: ${data['accountName']}', style: const TextStyle(fontSize: 16)),
                Text('Jumlah Transfer: Rp ${data['transferAmount']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                if (urls.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Belum ada bukti pembayaran yang diunggah.', style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic)),
                  ),

                // Looping untuk merender semua gambar (jika upload lebih dari 1 lembar)
                ...urls.map((url) {
                  final String cleanUrl = url.trim();
                  final String imageUrl = hostUrl + (cleanUrl.startsWith('/') ? cleanUrl : '/$cleanUrl');
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Text('Gagal memuat gambar: $imageUrl'),
                    ), 
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(), 
              child: const Text('Tutup', style: TextStyle(color: Colors.grey))
            ),
            ElevatedButton(
              onPressed: () {
                Get.back(); // close the image dialog first
                // Buka dialog input alasan
                final reasonCtrl = TextEditingController();
                Get.dialog(
                  AlertDialog(
                    title: const Text('Tolak Pembayaran'),
                    content: TextField(
                      controller: reasonCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Alasan Penolakan',
                        hintText: 'Misal: Bukti palsu, Uang kurang',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    actions: [
                      TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
                      ElevatedButton(
                        onPressed: () {
                          if (reasonCtrl.text.isEmpty) {
                            Get.snackbar('Gagal', 'Harap masukkan alasan penolakan');
                            return;
                          }
                          Get.back();
                          rejectPayment(orderId, reasonCtrl.text);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Tolak', style: TextStyle(color: Colors.white)),
                      )
                    ],
                  )
                );
              }, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Tolak', style: TextStyle(color: Colors.white))
            ),
            ElevatedButton(
              onPressed: () {
                Get.back(); // Tutup Pop-Up image view
                Get.defaultDialog(
                  title: 'Validasi Pembayaran',
                  middleText: 'Apakah Anda yakin pembayaran ini sudah masuk? Pesanan akan diteruskan ke Dapur (PROCESSING) dan stok akan dipotong final.',
                  textConfirm: 'Ya, Validasi',
                  textCancel: 'Batal',
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.green,
                  onConfirm: () {
                    Get.back(); // Close dialog
                    approvePayment(orderId); // Validasi pembayaran via Service
                  }
                );
              }, 
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Validasi & Terima', style: TextStyle(color: Colors.white))
            ),
          ],
        )
      );
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal memuat bukti pembayaran: $e', 
        backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
