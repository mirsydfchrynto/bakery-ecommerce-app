import '../../domain/repositories/catalog_repository.dart';
import '../datasource/catalog_remote_data_source.dart';
import '../models/product_model.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource remoteDataSource;

  CatalogRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductModel>> getProducts({int page = 0, int size = 20}) async {
    return await remoteDataSource.getActiveProducts(page: page, size: size);
  }
}
