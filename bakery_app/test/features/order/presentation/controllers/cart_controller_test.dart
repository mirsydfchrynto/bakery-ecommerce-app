import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:bakery_app/features/order/presentation/controllers/cart_controller.dart';
import 'package:bakery_app/features/catalog/data/models/product_model.dart';
import 'package:bakery_app/features/order/domain/usecases/checkout_usecase.dart';
import 'package:bakery_app/features/order/domain/repository/order_repository.dart';
import 'package:bakery_app/features/order/data/models/order_model.dart';

// Dummy Order Repository for Usecase
class DummyOrderRepository implements OrderRepository {
  @override
  Future<OrderModel> checkout(List<Map<String, dynamic>> items, Map<String, dynamic> shippingAddress) async {
    return OrderModel(id: 'test_order', status: 'PENDING', totalAmount: 0.0, orderedAt: DateTime.now().toIso8601String(), items: []);
  }
  @override
  Future<Map<String, dynamic>> getMyOrders({int page = 0, int size = 10, String? status}) async { return {'content': [], 'totalPages': 0}; }
  @override
  Future<Map<String, dynamic>> getAllOrders({int page = 0, int size = 10, String? status}) async { return {'content': [], 'totalPages': 0}; }
  @override
  Future<void> updateOrderStatus(String orderId, String status) async {}
}

void main() {
  Get.testMode = true;
  late CartController cartController;

  setUp(() {
    // Inisialisasi controller sebelum setiap test
    final dummyUsecase = CheckoutUseCase(DummyOrderRepository());
    cartController = CartController(dummyUsecase);
  });

  tearDown(() {
    // Hapus dari memory setelah test
    Get.delete<CartController>(force: true);
  });

  group('CartController Logic Tests', () {
    final product1 = ProductModel(
      id: 'prod-1',
      name: 'Roti Coklat',
      description: 'Enak',
      price: 15000,
      imageUrl: '',
      categoryName: 'Breads',
      stock: 50,
      status: 'ACTIVE',
    );

    final product2 = ProductModel(
      id: 'prod-2',
      name: 'Kue Tar',
      description: 'Manis',
      price: 50000,
      imageUrl: '',
      categoryName: 'Cakes',
      stock: 10,
      status: 'ACTIVE',
    );

    test('Initial cart should be empty', () {
      expect(cartController.items.isEmpty, true);
      expect(cartController.totalAmount, 0.0);
      expect(cartController.totalQuantity, 0);
    });

    test('Adding product to cart should increase quantity and update total', () {
      cartController.addToCart(product1);
      
      expect(cartController.items.length, 1);
      expect(cartController.items.first.quantity, 1);
      expect(cartController.totalQuantity, 1);
      expect(cartController.totalAmount, 15000.0);
    });

    test('Adding same product multiple times increases its quantity', () {
      cartController.addToCart(product1);
      cartController.addToCart(product1);
      
      expect(cartController.items.length, 1);
      expect(cartController.items.first.quantity, 2);
      expect(cartController.totalQuantity, 2);
      expect(cartController.totalAmount, 30000.0);
    });

    test('Adding multiple different products calculates total correctly', () {
      cartController.addToCart(product1); // 15000
      cartController.addToCart(product2); // 50000
      cartController.addToCart(product2); // 50000
      
      expect(cartController.items.length, 2);
      expect(cartController.totalQuantity, 3);
      expect(cartController.totalAmount, 115000.0);
    });

    test('Should not allow adding more than 20 items in total (Rule: max 20)', () {
      // Add 20 items of product 1
      for (int i = 0; i < 20; i++) {
        cartController.addToCart(product1);
      }
      
      expect(cartController.totalQuantity, 20);

      // Try adding 21st item
      cartController.addToCart(product2);
      
      // Should still be 20 because of the rule
      expect(cartController.totalQuantity, 20);
      // product2 shouldn't be added
      expect(cartController.items.any((element) => element.product.id == product2.id), false);
    });

    test('Removing product from cart', () {
      cartController.addToCart(product1);
      cartController.addToCart(product1);
      
      expect(cartController.totalQuantity, 2);
      
      cartController.removeFromCart(product1.id);
      
      expect(cartController.totalQuantity, 0);
      expect(cartController.totalAmount, 0.0);
      expect(cartController.items.isEmpty, true);
    });

    test('Clear cart should empty everything', () {
      cartController.addToCart(product1);
      cartController.addToCart(product2);
      
      cartController.clearCart();
      
      expect(cartController.totalQuantity, 0);
      expect(cartController.totalAmount, 0.0);
      expect(cartController.items.isEmpty, true);
    });
  });
}
