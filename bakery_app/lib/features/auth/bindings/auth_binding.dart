import 'package:get/get.dart';
import '../presentation/controllers/auth_controller.dart';
import '../presentation/controllers/forgot_password_controller.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../data/repository/auth_repository_impl.dart';
import '../data/datasource/auth_remote_data_source.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage_helper.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(Get.find<ApiClient>().dio),
    );
    Get.lazyPut<AuthRepositoryImpl>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        secureStorage: Get.find<SecureStorageHelper>(),
      ),
    );
    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(Get.find<AuthRepositoryImpl>()),
    );
    Get.lazyPut<RegisterUseCase>(
      () => RegisterUseCase(Get.find<AuthRepositoryImpl>()),
    );
    Get.lazyPut<AuthController>(
      () => AuthController(Get.find<LoginUseCase>(), Get.find<RegisterUseCase>()),
    );
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(Get.find<AuthRepositoryImpl>()),
    );
  }
}

