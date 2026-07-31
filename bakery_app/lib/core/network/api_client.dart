import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../storage/secure_storage_helper.dart';
import '../../routes/app_pages.dart';


import '../constants/app_config.dart';
class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final storage = Get.find<SecureStorageHelper>();
          final token = await storage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          // If 401 and not a refresh token request itself
          if (e.response?.statusCode == 401 && !e.requestOptions.path.contains('/auth/refresh')) {
            final storage = Get.find<SecureStorageHelper>();
            final refreshToken = await storage.getRefreshToken();
            
            if (refreshToken != null) {
              try {
                // Use a separate Dio instance to prevent infinite loops
                final refreshDio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl));
                final response = await refreshDio.post(
                  '/api/v1/auth/refresh',
                  data: {'refreshToken': refreshToken},
                );

                if (response.statusCode == 200) {
                  final newToken = response.data['data']['token'];
                  final newRefreshToken = response.data['data']['refreshToken'];
                  
                  await storage.saveToken(newToken);
                  if (newRefreshToken != null) {
                    await storage.saveRefreshToken(newRefreshToken);
                  }

                  // Replay the original request with new token
                  e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                  final cloneReq = await dio.fetch(e.requestOptions);
                  return handler.resolve(cloneReq);
                }
              } catch (_) {
                // If refresh fails, clear and logout
                await storage.clearAll();
                Get.offAllNamed(Routes.login);
                return handler.next(e);
              }
            }
            
            // If no refresh token available
            await storage.clearAll();
            Get.offAllNamed(Routes.login);
          }
          return handler.next(e);
        },
      ),
    );
  }
}
