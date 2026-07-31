import '../../../catalog/data/models/product_model.dart';
import '../../data/models/user_model.dart';

abstract class AdminRepository {
  Future<List<ProductModel>> getAdminProducts();
  Future<void> createProduct(String name, String description, double price, String imageUrl, {int stock = 100});
  Future<void> updateProduct(String id, String name, String description, double price, String imageUrl, String status, {int? stock});
  Future<void> deleteProduct(String id);
  Future<void> approvePayment(String orderId);
  Future<void> rejectPayment(String orderId, String reason);
  Future<Map<String, dynamic>> getPaymentDetails(String orderId);
  Future<String> uploadFile(String filePath);
  Future<List<UserModel>> getUsers();
  Future<void> deleteUser(String id);
  Future<Map<String, dynamic>> getDashboardAnalytics();
}
