import '../repository/order_repository.dart';


class GetMyOrdersUseCase {
  final OrderRepository repository;

  GetMyOrdersUseCase(this.repository);

  Future<Map<String, dynamic>> execute({int page = 0, int size = 10}) {
    return repository.getMyOrders(page: page, size: size);
  }
}
