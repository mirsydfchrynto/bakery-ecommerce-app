import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/product_model.dart';
import '../../../order/presentation/controllers/cart_controller.dart';

/// Menampilkan detail produk di sebuah Bottom Sheet.
/// Dipisahkan dari HomeScreen agar file tidak terlalu panjang (Maks 300 baris).
void showProductDetailsBottomSheet(BuildContext context, ProductModel product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Garis handle di atas bottom sheet
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Gambar Produk
          Container(
            height: 200,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xFFFAFAFA),
            ),
            child: (product.displayImageUrl != null)
                ? CachedNetworkImage(
                    imageUrl: product.displayImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.bakery_dining, size: 64, color: Colors.orange),
                  )
                : const Icon(Icons.bakery_dining, size: 64, color: Colors.orange),
          ),
          const SizedBox(height: 24),
          Text(
            product.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(product.price)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFFFF9800)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Deskripsi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            product.description ?? 'Tidak ada deskripsi tersedia.',
            style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 32),
          // Tombol Add to Cart
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: product.stock <= 0 ? null : () {
                Get.find<CartController>().addToCart(product);
                Get.back(); // Tutup bottom sheet
                Get.snackbar(
                  'Masuk Keranjang', 
                  '${product.name} berhasil ditambahkan!',
                  backgroundColor: const Color(0xFF4CAF50), 
                  colorText: Colors.white,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: product.stock <= 0 ? Colors.grey : const Color(0xFFFF9800),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                product.stock <= 0 ? 'Stok Habis' : 'Tambah ke Keranjang', 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
