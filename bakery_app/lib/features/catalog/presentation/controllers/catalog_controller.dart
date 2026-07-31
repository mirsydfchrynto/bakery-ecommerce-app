import 'package:get/get.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../data/models/product_model.dart';

class CatalogController extends GetxController with StateMixin<List<ProductModel>> {
  final GetProductsUseCase getProductsUseCase;

  CatalogController(this.getProductsUseCase);

  int currentPage = 0;
  bool isLastPage = false;
  bool isLoadingMore = false;
  final int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts({bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      isLastPage = false;
    }
    
    if (currentPage == 0) {
      change(null, status: RxStatus.loading());
    } else {
      isLoadingMore = true;
      update();
    }
    
    try {
      final newProducts = await getProductsUseCase.execute(page: currentPage, size: pageSize);
      
      if (newProducts.length < pageSize) {
        isLastPage = true;
      }
      
      if (currentPage == 0) {
        if (newProducts.isEmpty) {
          change([], status: RxStatus.empty());
        } else {
          change(newProducts, status: RxStatus.success());
        }
      } else {
        final currentProducts = state ?? [];
        currentProducts.addAll(newProducts);
        change(currentProducts, status: RxStatus.success());
      }
      
      if (!isLastPage) {
        currentPage++;
      }
      
      isLoadingMore = false;
      update();
    } catch (e) {
      if (currentPage == 0) {
        change(null, status: RxStatus.error(e.toString()));
      }
      isLoadingMore = false;
      update();
    }
  }

  Future<void> fetchNextPage() async {
    if (isLastPage || isLoadingMore) return;
    await fetchProducts();
  }
}
