import 'package:dio/dio.dart';
import '../models/product_model.dart';

abstract class CatalogRemoteDataSource {
  Future<List<ProductModel>> getActiveProducts({int page = 0, int size = 20});
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final Dio dio;

  CatalogRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getActiveProducts({int page = 0, int size = 20}) async {
    final response = await dio.get('/products', queryParameters: {'page': page, 'size': size});
    
    if (response.data['success'] == true) {
      final List<dynamic> data = response.data['data']['content'] ?? response.data['data'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch products');
    }
  }
}
