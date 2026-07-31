import '../../data/models/order_model.dart';

abstract class OrderRepository {
  Future<OrderModel> checkout(List<Map<String, dynamic>> items, Map<String, dynamic> shippingAddress);
  Future<Map<String, dynamic>> getMyOrders({int page = 0, int size = 10});
  Future<Map<String, dynamic>> getAllOrders({int page = 0, int size = 10, String? status});
  Future<void> updateOrderStatus(String orderId, String status);
}
