import 'package:get/get.dart';
import '../presentation/controllers/catalog_controller.dart';
import '../domain/usecases/get_products_usecase.dart';
import '../data/repository/catalog_repository_impl.dart';
import '../data/datasource/catalog_remote_data_source.dart';
import '../../../../core/network/api_client.dart';
import '../../order/presentation/controllers/cart_controller.dart';
import '../../order/domain/usecases/checkout_usecase.dart';
import '../../order/data/repository/order_repository_impl.dart';
import '../../order/data/datasource/order_remote_data_source.dart';
import '../../auth/data/datasource/auth_remote_data_source.dart';
import '../../auth/data/repository/auth_repository_impl.dart';
import '../../auth/domain/repositories/auth_repository.dart';
import '../../auth/presentation/controllers/profile_controller.dart';
import '../../../../core/storage/secure_storage_helper.dart';
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CatalogRemoteDataSource>(
      () => CatalogRemoteDataSourceImpl(Get.find<ApiClient>().dio),
    );
    Get.lazyPut<CatalogRepositoryImpl>(
      () => CatalogRepositoryImpl(remoteDataSource: Get.find<CatalogRemoteDataSource>()),
    );
    Get.lazyPut<GetProductsUseCase>(
      () => GetProductsUseCase(Get.find<CatalogRepositoryImpl>()),
    );
    Get.lazyPut<CatalogController>(
      () => CatalogController(Get.find<GetProductsUseCase>()),
    );
    
    // Order Domain Injections
    Get.lazyPut<OrderRemoteDataSource>(
      () => OrderRemoteDataSourceImpl(Get.find<ApiClient>().dio),
    );
    Get.lazyPut<OrderRepositoryImpl>(
      () => OrderRepositoryImpl(remoteDataSource: Get.find<OrderRemoteDataSource>()),
    );
    Get.lazyPut<CheckoutUseCase>(
      () => CheckoutUseCase(Get.find<OrderRepositoryImpl>()),
    );
    
    Get.put<CartController>(CartController(Get.find<CheckoutUseCase>()), permanent: true);
    
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(Get.find<ApiClient>().dio),
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        secureStorage: Get.find<SecureStorageHelper>(),
      ),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find<AuthRepository>()),
    );
  }
}
