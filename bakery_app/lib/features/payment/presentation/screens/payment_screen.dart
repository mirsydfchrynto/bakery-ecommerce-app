import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../controllers/payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments;
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controller.handleBackPress(order['orderId']);
      },
      child: Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A1A)),
          onPressed: () => controller.handleBackPress(order['orderId']),
        ),
        title: const Text(
          'Pembayaran',
          style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w800, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('Total yang Harus Dibayar', style: TextStyle(fontSize: 16, color: Color(0xFF757575))),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(order['totalAmount'])}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFFFF9800)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Instruksi Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 16),
            _buildInstructionStep('1', 'Transfer sesuai nominal total ke:'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(left: 40),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Bank BCA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('1234567890', style: TextStyle(fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('a.n. Bakery Shop', style: TextStyle(color: Color(0xFF757575))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInstructionStep('2', 'Ambil screenshot atau foto bukti transfer.'),
            const SizedBox(height: 16),
            _buildInstructionStep('3', 'Unggah bukti di bawah (Maks 5 gambar).'),
            const SizedBox(height: 24),
            Obx(() => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ...controller.selectedImages.asMap().entries.map((entry) {
                  return Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(File(entry.value.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => controller.removeImage(entry.key),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                if (controller.selectedImages.length < 5)
                  GestureDetector(
                    onTap: controller.pickImages,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0), width: 2, style: BorderStyle.solid),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_rounded, color: Color(0xFFBDBDBD), size: 32),
                          SizedBox(height: 4),
                          Text('Unggah', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
              ],
            )),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : () => controller.submitPayment(order),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9800),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              disabledBackgroundColor: const Color(0xFFFF9800).withValues(alpha: 0.5),
            ),
            child: controller.isLoading.value
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Konfirmasi Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          )),
        ),
      ),
    ));
  }

  Widget _buildInstructionStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0xFFFF9800),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Color(0xFF424242), height: 1.5),
          ),
        ),
      ],
    );
  }
}
