import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/admin_products_controller.dart';
import '../../../catalog/data/models/product_model.dart';
import '../../../../core/widget/primary_button.dart';
import '../widgets/admin_drawer.dart';

class AdminProductsScreen extends GetView<AdminProductsController> {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      drawer: const AdminDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        title: const Text(
          'Kelola Katalog',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFFFF9800)),
            onPressed: () => _showProductDialog(context, null),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: TextField(
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Cari produk...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFFF9800), width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: controller.obx(
              (products) {
                return RefreshIndicator(
                  onRefresh: () => controller.fetchProducts(),
                  color: const Color(0xFFFF9800),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24.0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: products!.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildProductCard(context, product);
                    },
                  ),
                );
              },
              onLoading: const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800))),
              onEmpty: const Center(
                child: Text(
                  'Produk tidak ditemukan.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              onError: (error) => Center(
                child: Text(
                  'Gagal: $error',
                  style: const TextStyle(color: Color(0xFFE53935)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
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
                        const Icon(Icons.bakery_dining_rounded, color: Colors.black26, size: 32),
                  )
                : const Icon(Icons.image_not_supported_rounded, color: Colors.black26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(product.price)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFF9800),
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Status: ${product.status}',
                      style: TextStyle(
                        fontSize: 12,
                        color: product.status == 'ACTIVE' ? const Color(0xFF43A047) : Colors.black54,
                      ),
                    ),
                    Text(
                      '• Stok: ${product.stock}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: product.stock < 10 ? const Color(0xFFE53935) : Colors.black54,
                      ),
                    ),
                    if (product.stock < 10)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Stok Menipis',
                          style: TextStyle(fontSize: 10, color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFFB8C00)),
                    tooltip: 'Kurangi Stok',
                    onPressed: () {
                      if (product.stock > 0) {
                        controller.updateProduct(
                          product.id, product.name, product.description ?? '',
                          product.price, product.imageUrl ?? '', product.status, product.stock - 1,
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFF43A047)),
                    tooltip: 'Tambah Stok',
                    onPressed: () {
                      controller.updateProduct(
                        product.id, product.name, product.description ?? '',
                        product.price, product.imageUrl ?? '', product.status, product.stock + 1,
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF1E88E5)),
                    onPressed: () => _showProductDialog(context, product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE53935)),
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Hapus Produk',
                        middleText: 'Apakah Anda yakin ingin menghapus ${product.name}?',
                        textConfirm: 'Hapus',
                        textCancel: 'Batal',
                        confirmTextColor: Colors.white,
                        buttonColor: const Color(0xFFE53935),
                        backgroundColor: Colors.white,
                        titleStyle: const TextStyle(color: Colors.black87),
                        middleTextStyle: const TextStyle(color: Colors.black87),
                        cancelTextColor: Colors.black54,
                        onConfirm: () {
                          controller.deleteProduct(product.id);
                          Get.back();
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showProductDialog(BuildContext context, ProductModel? product) {
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final descCtrl = TextEditingController(text: product?.description ?? '');
    final priceCtrl = TextEditingController(text: product?.price.toString() ?? '');
    final stockCtrl = TextEditingController(text: product?.stock.toString() ?? '100');
    String status = product?.status ?? 'ACTIVE';
    String? uploadedImageUrl = product?.imageUrl;

    Get.bottomSheet(
      StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  product == null ? 'Tambah Produk Baru' : 'Edit Produk',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Produk', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Deskripsi', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Harga', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: stockCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Stok', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty
                            ? 'Gambar Terunggah'
                            : 'Tidak ada gambar dipilih',
                        style: TextStyle(
                          color: uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Pilih Gambar'),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          final url = await controller.uploadProductImage(pickedFile.path);
                          if (url != null) {
                            setState(() {
                              uploadedImageUrl = url;
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (product != null)
                  DropdownButtonFormField<String>(
                    initialValue: status,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'ACTIVE', child: Text('AKTIF (ACTIVE)')),
                      DropdownMenuItem(value: 'DRAFT', child: Text('DRAF (DRAFT)')),
                      DropdownMenuItem(value: 'ARCHIVED', child: Text('ARSIP (ARCHIVED)')),
                    ],
                    onChanged: (val) {
                      if (val != null) status = val;
                    },
                  ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Simpan Produk',
                  onPressed: () {
                    final price = double.tryParse(priceCtrl.text) ?? 0.0;
                    final stock = int.tryParse(stockCtrl.text) ?? 0;
                    if (product == null) {
                      controller.createProduct(nameCtrl.text, descCtrl.text, price, uploadedImageUrl ?? '', stock);
                    } else {
                      controller.updateProduct(product.id, nameCtrl.text, descCtrl.text, price, uploadedImageUrl ?? '', status, stock);
                    }
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      }),
      isScrollControlled: true,
    );
  }
}
