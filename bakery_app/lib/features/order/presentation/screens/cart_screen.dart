import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widget/primary_button.dart';
import '../../../catalog/presentation/controllers/main_screen_controller.dart';
import '../controllers/cart_controller.dart';
import 'map_picker_screen.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
        final items = controller.items;
        final itemCount = controller.itemCount;
        final subtotal = controller.totalAmount;
        final deliveryFee = items.isEmpty ? 0.0 : 15000.0; // Flat fee IDR 15,000
        final total = subtotal + deliveryFee;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A1A)),
                        onPressed: () {
                          if (Get.isRegistered<MainScreenController>()) {
                            Get.find<MainScreenController>().changeTab(0);
                          } else {
                            Get.back();
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Keranjang Saya',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '$itemCount Barang',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF9800).withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text(
                        'Keranjang Anda kosong',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF757575),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _buildCartItem(item);
                      },
                    ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 24.0, 
                right: 24.0, 
                top: 24.0, 
                bottom: 24.0 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: TextStyle(color: Color(0xFF757575), fontSize: 16)),
                      Text('Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(subtotal)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Pengiriman', style: TextStyle(color: Color(0xFF757575), fontSize: 16)),
                      Text('Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(deliveryFee)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(total)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFF9800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Pesan Sekarang',
                    onPressed: items.isEmpty ? null : () => _showAddressForm(context),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    ));
  }

  void _showAddressForm(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    
    // Store coordinates
    double lat = -6.200000;
    double lng = 106.816666;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Alamat Pengiriman',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Penerima', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Nomor Telepon', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: addressCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'Alamat Lengkap', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () async {
                      // Navigate to Map Picker
                      final result = await Get.to(() => const MapPickerScreen());
                      if (result != null) {
                        addressCtrl.text = result['address'];
                        lat = result['latitude'];
                        lng = result['longitude'];
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFF9800)),
                      ),
                      child: const Icon(Icons.map_rounded, color: Color(0xFFFF9800)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Konfirmasi & Bayar',
                onPressed: () {
                  if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty || addressCtrl.text.isEmpty) {
                    Get.snackbar('Gagal', 'Mohon isi semua kolom alamat');
                    return;
                  }
                  
                  Get.back(); // close sheet
                  
                  final addressData = {
                    'recipientName': nameCtrl.text,
                    'phoneNumber': phoneCtrl.text,
                    'fullAddress': addressCtrl.text,
                    'latitude': lat,
                    'longitude': lng
                  };
                  
                  controller.checkout(addressData);
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: (item.product.displayImageUrl != null)
                ? CachedNetworkImage(
                    imageUrl: item.product.displayImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey[200]),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.bakery_dining_rounded, color: Colors.black26, size: 24),
                  )
                : const Icon(Icons.image_not_supported_rounded, color: Colors.black26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(item.product.price)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFF9800),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => controller.updateQuantity(item.product.id, item.quantity - 1),
                child: _buildQtyButton(Icons.remove_rounded),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              GestureDetector(
                onTap: () => controller.updateQuantity(item.product.id, item.quantity + 1),
                child: _buildQtyButton(Icons.add_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 20, color: const Color(0xFF1A1A1A)),
    );
  }
}
