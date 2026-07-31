import 'package:get/get.dart';
import '../domain/usecases/get_my_orders_usecase.dart';
import '../presentation/controllers/order_history_controller.dart';
import '../data/repository/order_repository_impl.dart';

class OrderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetMyOrdersUseCase>(
      () => GetMyOrdersUseCase(Get.find<OrderRepositoryImpl>()),
    );
    Get.lazyPut<OrderHistoryController>(
      () => OrderHistoryController(Get.find<GetMyOrdersUseCase>()),
    );
  }
}
