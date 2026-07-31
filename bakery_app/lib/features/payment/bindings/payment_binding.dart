import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../data/datasource/payment_remote_data_source.dart';
import '../presentation/controllers/payment_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentRemoteDataSource>(
      () => PaymentRemoteDataSourceImpl(Get.find<ApiClient>().dio),
    );
    Get.lazyPut<PaymentController>(
      () => PaymentController(Get.find<PaymentRemoteDataSource>()),
    );
  }
}
