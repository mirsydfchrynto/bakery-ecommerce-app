import 'package:get/get.dart';
import '../../../catalog/data/models/product_model.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminProductsController extends GetxController with StateMixin<List<ProductModel>> {
  final AdminRepository repository;

  AdminProductsController(this.repository);

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  var searchQuery = ''.obs;
  List<ProductModel> _allProducts = [];

  Future<void> fetchProducts() async {
    change(null, status: RxStatus.loading());
    try {
      _allProducts = await repository.getAdminProducts();
      if (_allProducts.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(filteredProducts, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (_allProducts.isEmpty) {
      change([], status: RxStatus.empty());
    } else {
      final filtered = filteredProducts;
      if (filtered.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(filtered, status: RxStatus.success());
      }
    }
  }

  List<ProductModel> get filteredProducts {
    if (searchQuery.value.isEmpty) return _allProducts;
    return _allProducts.where((p) => p.name.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }

  Future<void> createProduct(String name, String description, double price, String imageUrl, int stock) async {
    try {
      await repository.createProduct(name, description, price, imageUrl, stock: stock);
      Get.snackbar('Berhasil', 'Produk berhasil dibuat');
      fetchProducts();
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak dapat membuat produk: $e');
    }
  }

  Future<void> updateProduct(String id, String name, String description, double price, String imageUrl, String status, int stock) async {
    try {
      await repository.updateProduct(id, name, description, price, imageUrl, status, stock: stock);
      Get.snackbar('Berhasil', 'Produk berhasil diperbarui');
      fetchProducts();
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak dapat memperbarui produk: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await repository.deleteProduct(id);
      Get.snackbar('Berhasil', 'Produk berhasil dihapus');
      fetchProducts();
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak dapat menghapus produk: $e');
    }
  }

  Future<String?> uploadProductImage(String filePath) async {
    try {
      change(state, status: RxStatus.loading()); // show loading
      final url = await repository.uploadFile(filePath);
      change(state, status: RxStatus.success()); // restore state
      return url;
    } catch (e) {
      change(state, status: RxStatus.success());
      Get.snackbar('Gagal', 'Tidak dapat mengunggah gambar: $e');
      return null;
    }
  }
}
