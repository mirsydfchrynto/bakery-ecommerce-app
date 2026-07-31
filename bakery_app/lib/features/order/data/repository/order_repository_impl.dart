import '../../domain/repository/order_repository.dart';
import '../datasource/order_remote_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrderModel> checkout(List<Map<String, dynamic>> items, Map<String, dynamic> shippingAddress) async {
    final payload = {
      'items': items,
      'shippingAddress': shippingAddress,
    };
    final response = await remoteDataSource.checkout(payload);
    return OrderModel.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> getMyOrders({int page = 0, int size = 10}) async {
    final response = await remoteDataSource.getMyOrders(page: page, size: size);
    final content = (response['content'] as List)
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return {
      'content': content,
      'totalPages': response['totalPages'] ?? 1,
      'totalElements': response['totalElements'] ?? 0,
    };
  }

  @override
  Future<Map<String, dynamic>> getAllOrders({int page = 0, int size = 10, String? status}) async {
    final response = await remoteDataSource.getAllOrders(page: page, size: size, status: status);
    final content = (response['content'] as List)
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return {
      'content': content,
      'totalPages': response['totalPages'] ?? 1,
      'totalElements': response['totalElements'] ?? 0,
    };
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    await remoteDataSource.updateOrderStatus(orderId, status);
  }
}
