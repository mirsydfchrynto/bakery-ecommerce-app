import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../data/datasource/admin_remote_data_source.dart';
import '../data/repository/admin_repository_impl.dart';
import '../domain/repositories/admin_repository.dart';
import '../presentation/controllers/admin_dashboard_controller.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminRemoteDataSource>(() => AdminRemoteDataSourceImpl(Get.find<ApiClient>().dio));
    Get.lazyPut<AdminRepository>(() => AdminRepositoryImpl(Get.find<AdminRemoteDataSource>()));
    Get.lazyPut<AdminDashboardController>(() => AdminDashboardController(Get.find<AdminRepository>()));
  }
}
