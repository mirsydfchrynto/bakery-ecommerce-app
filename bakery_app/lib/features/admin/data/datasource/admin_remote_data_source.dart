import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../catalog/data/models/product_model.dart';

abstract class AdminRemoteDataSource {
  Future<List<ProductModel>> getAdminProducts();
  Future<void> createProduct(String name, String description, double price, String imageUrl, {int stock = 100});
  Future<void> updateProduct(String id, String name, String description, double price, String imageUrl, String status, {int? stock});
  Future<void> deleteProduct(String id);
  Future<void> approvePayment(String orderId);
  Future<void> rejectPayment(String orderId, String reason);
  Future<Map<String, dynamic>> getPaymentDetails(String orderId);
  Future<String> uploadFile(String filePath);
  Future<List<dynamic>> getUsers();
  Future<void> deleteUser(String id);
  Future<Map<String, dynamic>> getDashboardAnalytics();
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getAdminProducts() async {
    final response = await dio.get('/products/admin');
    if (response.statusCode == 200) {
      final rawData = response.data['data']['content'] ?? response.data['data'];
      return (rawData as List).map((e) => ProductModel.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch admin products');
  }

  @override
  Future<void> createProduct(String name, String description, double price, String imageUrl, {int stock = 100}) async {
    final response = await dio.post('/admin/products', data: {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'stock': stock,
    });
    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to create product');
    }
  }

  @override
  Future<void> updateProduct(String id, String name, String description, double price, String imageUrl, String status, {int? stock}) async {
    final data = {
      'name': name,
      'description': description,
      'price': price,
      'status': status,
      'imageUrl': imageUrl,
    };
    if (stock != null) {
      data['stock'] = stock;
    }
    final response = await dio.put('/admin/products/$id', data: data);
    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to update product');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await dio.delete('/products/admin/$id');
  }

  @override
  Future<void> approvePayment(String orderId) async {
    await dio.put('/payments/admin/$orderId/accept');
  }

  @override
  Future<void> rejectPayment(String orderId, String reason) async {
    await dio.put('/payments/admin/$orderId/reject?reason=$reason');
  }

  @override
  Future<Map<String, dynamic>> getPaymentDetails(String orderId) async {
    final response = await dio.get('/payments/admin/$orderId');
    if (response.data['success'] == true) {
      return response.data['data'];
    }
    throw Exception('Failed to load payment proof');
  }

  @override
  Future<String> uploadFile(String filePath) async {
    final fileName = filePath.split('/').last;
    final ext = fileName.split('.').last.toLowerCase();
    
    String mimeType = 'image/jpeg'; // default
    if (ext == 'png') {
      mimeType = 'image/png';
    } else if (ext == 'jpg' || ext == 'jpeg') {
      mimeType = 'image/jpeg';
    }

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      ),
    });
    final response = await dio.post('/storage/upload', data: formData);
    if (response.statusCode == 200) {
      return response.data['data']['url'];
    }
    throw Exception('Failed to upload file');
  }

  @override
  Future<List<dynamic>> getUsers() async {
    final response = await dio.get('/admin/users');
    if (response.data['success'] == true) {
      return response.data['data']['content'] as List<dynamic>;
    }
    throw Exception(response.data['message'] ?? 'Failed to fetch users');
  }

  @override
  Future<void> deleteUser(String id) async {
    final response = await dio.delete('/admin/users/$id');
    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to delete user');
    }
  }

  @override
  Future<Map<String, dynamic>> getDashboardAnalytics() async {
    final response = await dio.get('/admin/dashboard');
    if (response.data['success'] == true) {
      return response.data['data'];
    }
    throw Exception('Failed to fetch dashboard data');
  }
}
