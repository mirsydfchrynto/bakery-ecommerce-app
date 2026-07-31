import '../../data/models/product_model.dart';

abstract class CatalogRepository {
  Future<List<ProductModel>> getProducts({int page = 0, int size = 20});
}
