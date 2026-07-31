import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../presentation/controllers/admin_orders_controller.dart';
import '../../order/data/repository/order_repository_impl.dart';
import '../domain/repositories/admin_repository.dart';
import '../data/datasource/admin_remote_data_source.dart';
import '../data/repository/admin_repository_impl.dart';
import '../../order/data/datasource/order_remote_data_source.dart';

class AdminOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminRemoteDataSource>(
      () => AdminRemoteDataSourceImpl(Get.find<ApiClient>().dio),
    );
    Get.lazyPut<AdminRepository>(
      () => AdminRepositoryImpl(Get.find<AdminRemoteDataSource>()),
    );
    Get.lazyPut<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(Get.find<ApiClient>().dio),
    );
    Get.lazyPut<OrderRepositoryImpl>(
      () => OrderRepositoryImpl(remoteDataSource: Get.find<OrderRemoteDataSource>()),
    );
    Get.lazyPut<AdminOrdersController>(
      () => AdminOrdersController(Get.find<OrderRepositoryImpl>(), Get.find<AdminRepository>()),
    );
  }
}
