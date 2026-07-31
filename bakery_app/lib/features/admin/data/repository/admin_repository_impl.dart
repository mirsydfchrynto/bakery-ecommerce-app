import '../../../catalog/data/models/product_model.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasource/admin_remote_data_source.dart';
import '../models/user_model.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductModel>> getAdminProducts() async {
    return await remoteDataSource.getAdminProducts();
  }

  @override
  Future<void> createProduct(String name, String description, double price, String imageUrl, {int stock = 100}) async {
    return remoteDataSource.createProduct(name, description, price, imageUrl, stock: stock);
  }

  @override
  Future<void> updateProduct(String id, String name, String description, double price, String imageUrl, String status, {int? stock}) async {
    return remoteDataSource.updateProduct(id, name, description, price, imageUrl, status, stock: stock);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDataSource.deleteProduct(id);
  }

  @override
  Future<void> approvePayment(String orderId) {
    return remoteDataSource.approvePayment(orderId);
  }

  @override
  Future<void> rejectPayment(String orderId, String reason) {
    return remoteDataSource.rejectPayment(orderId, reason);
  }

  @override
  Future<Map<String, dynamic>> getPaymentDetails(String orderId) async {
    return await remoteDataSource.getPaymentDetails(orderId);
  }

  @override
  Future<String> uploadFile(String filePath) async {
    return remoteDataSource.uploadFile(filePath);
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final list = await remoteDataSource.getUsers();
    return list.map((e) => UserModel.fromJson(e)).toList();
  }

  @override
  Future<void> deleteUser(String id) async {
    return remoteDataSource.deleteUser(id);
  }

  @override
  Future<Map<String, dynamic>> getDashboardAnalytics() async {
    return remoteDataSource.getDashboardAnalytics();
  }
}
