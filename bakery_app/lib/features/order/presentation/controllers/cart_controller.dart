import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../catalog/data/models/product_model.dart';
import '../../domain/usecases/checkout_usecase.dart';

/// Model internal untuk item keranjang (Cart Item).
class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

/// CartController bertugas mengatur state keranjang belanja (tambah, kurangi, hapus produk).
class CartController extends GetxController {
  final CheckoutUseCase _checkoutUseCase;
  
  CartController(this._checkoutUseCase);

  // Menyimpan daftar belanja menggunakan tipe data Map agar pencarian/pengubahan cepat (O(1)).
  // Menggunakan .obs (Observable) dari GetX agar UI otomatis bereaksi jika data ini berubah.
  final _items = <String, CartItem>{}.obs;

  List<CartItem> get items => _items.values.toList();
  
  /// Mengambil total harga dari seluruh item di keranjang
  double get totalAmount {
    double total = 0;
    for (var item in _items.values) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  int get itemCount => _items.length;

  int get totalQuantity {
    int total = 0;
    for (var item in _items.values) {
      total += item.quantity;
    }
    return total;
  }

  /// Fungsi untuk menambah produk ke keranjang. 
  /// Jika sudah ada, tambahkan kuantitasnya. Jika belum, masukkan data baru.
  void addToCart(ProductModel product) {
    if (totalQuantity >= 20) {
      if (!Get.testMode) {
        Get.snackbar('Batas Tercapai', 'Maksimal pemesanan adalah 20 barang.',
            backgroundColor: const Color(0xFFF44336), colorText: Colors.white);
      }
      return;
    }

    if (_items.containsKey(product.id)) {
      _items.update(product.id, (value) {
        value.quantity += 1;
        return value;
      });
    } else {
      _items.putIfAbsent(product.id, () => CartItem(product: product));
    }
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
  }

  /// Fungsi mengatur kuantitas. Jika 0, produk akan dihapus dari keranjang.
  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final currentItem = _items[productId];
    if (currentItem != null) {
      int difference = newQuantity - currentItem.quantity;
      if (difference > 0 && totalQuantity + difference > 20) {
        if (!Get.testMode) {
          Get.snackbar('Batas Tercapai', 'Maksimal pemesanan adalah 20 barang.',
              backgroundColor: const Color(0xFFF44336), colorText: Colors.white);
        }
        return;
      }
      
      _items.update(productId, (value) {
        value.quantity = newQuantity;
        return value;
      });
    }
  }

  void clearCart() {
    _items.clear();
  }

  /// Mengeksekusi proses Checkout menembak API.
  Future<void> checkout(Map<String, dynamic> addressData) async {
    if (_items.isEmpty) return;
    
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    
    try {
      // 1. Memformat data keranjang agar sesuai dengan yang diminta Backend (DTO)
      final orderItems = _items.values.map((item) => {
        'productId': item.product.id,
        'quantity': item.quantity,
      }).toList();

      // 3. Menembak API Checkout
      final order = await _checkoutUseCase.execute(orderItems, addressData);
      
      // 4. Jika sukses, kosongkan keranjang dan navigasi ke halaman Pembayaran
      clearCart();
      Get.back(); // Tutup loading dialog
      Get.snackbar('Berhasil', 'Pesanan berhasil dibuat!',
          backgroundColor: const Color(0xFF4CAF50), colorText: const Color(0xFFFFFFFF));
          
      // Arahkan ke halaman pembayaran (Payment) agar pelanggan bisa bayar
      Get.offNamed('/payment', arguments: {'orderId': order.id, 'totalAmount': order.totalAmount});
      
    } catch (e) {
      Get.back(); // Tutup loading dialog
      Get.snackbar('Gagal', 'Checkout Gagal: ${e.toString()}',
          backgroundColor: const Color(0xFFF44336), colorText: const Color(0xFFFFFFFF));
    }
  }
}
