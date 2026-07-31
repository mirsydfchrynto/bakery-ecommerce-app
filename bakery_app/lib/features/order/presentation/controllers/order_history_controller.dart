import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/get_my_orders_usecase.dart';
import '../../data/models/order_model.dart';

class OrderHistoryController extends GetxController with StateMixin<List<OrderModel>> {
  final GetMyOrdersUseCase _getMyOrdersUseCase;

  OrderHistoryController(this._getMyOrdersUseCase);

  final ScrollController scrollController = ScrollController();
  int currentPage = 0;
  int totalPages = 1;
  bool isLoadingMore = false;
  List<OrderModel> orders = [];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      loadMoreOrders();
    }
  }

  Future<void> fetchOrders() async {
    currentPage = 0;
    change(null, status: RxStatus.loading());
    try {
      final result = await _getMyOrdersUseCase.execute(page: currentPage, size: 10);
      orders = result['content'] as List<OrderModel>;
      totalPages = result['totalPages'];
      
      if (orders.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(List.from(orders), status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> loadMoreOrders() async {
    if (isLoadingMore || currentPage >= totalPages - 1) return;
    
    isLoadingMore = true;
    currentPage++;
    update(); // To show loading indicator at the bottom if needed
    
    try {
      final result = await _getMyOrdersUseCase.execute(page: currentPage, size: 10);
      final newOrders = result['content'] as List<OrderModel>;
      totalPages = result['totalPages'];
      orders.addAll(newOrders);
      change(List.from(orders), status: RxStatus.success());
    } catch (e) {
      // Revert page if failed
      currentPage--;
      Get.snackbar('Error', 'Failed to load more orders: ${e.toString()}');
    } finally {
      isLoadingMore = false;
      update();
    }
  }
}
