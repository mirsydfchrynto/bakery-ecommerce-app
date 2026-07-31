import '../repository/order_repository.dart';

import '../../data/models/order_model.dart';

class CheckoutUseCase {
  final OrderRepository repository;

  CheckoutUseCase(this.repository);

  Future<OrderModel> execute(List<Map<String, dynamic>> items, Map<String, dynamic> shippingAddress) async {
    return await repository.checkout(items, shippingAddress);
  }
}
