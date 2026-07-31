import 'package:dio/dio.dart';

abstract class OrderRemoteDataSource {
  Future<Map<String, dynamic>> checkout(Map<String, dynamic> checkoutData);
  Future<Map<String, dynamic>> getMyOrders({int page = 0, int size = 10});
  Future<Map<String, dynamic>> getAllOrders({int page = 0, int size = 10, String? status});
  Future<dynamic> updateOrderStatus(String orderId, String status);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio _dio;

  OrderRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> checkout(Map<String, dynamic> checkoutData) async {
    final response = await _dio.post('/orders', data: checkoutData);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response.data['data'] as Map<String, dynamic>;
    } else {
      throw Exception(response.data['message'] ?? 'Checkout failed');
    }
  }

  @override
  Future<Map<String, dynamic>> getMyOrders({int page = 0, int size = 10}) async {
    final response = await _dio.get('/orders?page=$page&size=$size');
    if (response.statusCode == 200) {
      return response.data['data'] as Map<String, dynamic>; // Returns Page object
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch orders');
    }
  }

  @override
  Future<Map<String, dynamic>> getAllOrders({int page = 0, int size = 10, String? status}) async {
    String url = '/admin/orders?page=$page&size=$size';
    if (status != null && status != 'All') {
      url += '&status=$status';
    }
    final response = await _dio.get(url);
    if (response.statusCode == 200) {
      return response.data['data'] as Map<String, dynamic>; // Returns Page object
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch all orders');
    }
  }

  @override
  Future<dynamic> updateOrderStatus(String orderId, String status) async {
    final response = await _dio.put('/orders/admin/$orderId/status?status=$status');
    if (response.statusCode == 200) {
      return response.data['data'];
    } else {
      throw Exception(response.data['message'] ?? 'Failed to update order status');
    }
  }
}
