import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/product_model.dart';
import '../../../order/presentation/controllers/cart_controller.dart';
import 'product_details_bottom_sheet.dart';

/// Widget Kartu Produk untuk menampilkan gambar, nama, dan harga.
/// Dipisahkan agar HomeScreen tidak melebihi 300 baris.
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final IconData fallbackIcon;

  const ProductCard({
    super.key,
    required this.product,
    this.fallbackIcon = Icons.bakery_dining_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    
    return GestureDetector(
      // Saat ditekan, buka detail produk (Bottom Sheet)
      onTap: () => showProductDetailsBottomSheet(context, product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Area Gambar Produk
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
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
                              Icon(fallbackIcon, size: 64, color: const Color(0xFFFF9800).withValues(alpha: 0.5)),
                        )
                      : Icon(fallbackIcon, size: 64, color: const Color(0xFFFF9800).withValues(alpha: 0.5)),
                ),
              ),
              if (product.stock <= 0)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Habis', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              const SizedBox(height: 12),
              // Nama Produk
              Text(
                product.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Deskripsi Singkat
              Text(
                product.description ?? '',
                style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Harga & Tombol Tambah
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(product.price)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFFFF9800)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: product.stock <= 0 ? null : () {
                      cartController.addToCart(product);
                      Get.snackbar(
                        'Keranjang', 
                        '${product.name} ditambahkan ke keranjang!', 
                        backgroundColor: const Color(0xFF4CAF50), 
                        colorText: Colors.white
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: product.stock <= 0 ? Colors.grey : const Color(0xFF1A1A1A), 
                        shape: BoxShape.circle
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
