import '../repositories/catalog_repository.dart';
import '../../data/models/product_model.dart';

class GetProductsUseCase {
  final CatalogRepository repository;

  GetProductsUseCase(this.repository);

  Future<List<ProductModel>> execute({int page = 0, int size = 20}) async {
    return await repository.getProducts(page: page, size: size);
  }
}
