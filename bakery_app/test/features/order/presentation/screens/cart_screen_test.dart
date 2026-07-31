import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:bakery_app/features/order/presentation/screens/cart_screen.dart';
import 'package:bakery_app/features/order/presentation/controllers/cart_controller.dart';
import 'package:bakery_app/features/catalog/data/models/product_model.dart';
import 'package:bakery_app/features/order/domain/usecases/checkout_usecase.dart';
import 'package:bakery_app/features/order/domain/repository/order_repository.dart';
import 'package:bakery_app/features/order/data/models/order_model.dart';

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
  setUp(() {
    final dummyUsecase = CheckoutUseCase(DummyOrderRepository());
    Get.put<CartController>(CartController(dummyUsecase));
  });

  tearDown(() {
    Get.delete<CartController>(force: true);
  });

  Widget createWidgetUnderTest() {
    return GetMaterialApp(
      home: const CartScreen(),
    );
  }

  testWidgets('Cart screen shows empty state when no items', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    
    // Verify empty state UI
    expect(find.text('Your cart is empty'), findsOneWidget);
  });

  testWidgets('Cart screen shows items and total price when items added', (WidgetTester tester) async {
    final controller = Get.find<CartController>();
    
    final product = ProductModel(
      id: 'prod-1',
      name: 'Roti Coklat',
      price: 15000,
      status: 'ACTIVE',
    );
    
    // Add item to cart state
    controller.addToCart(product);
    
    await tester.pumpWidget(createWidgetUnderTest());
    
    // Verify item is visible
    expect(find.text('Roti Coklat'), findsOneWidget);
    // Verify total price is visible (Format from NumberFormat with space after Rp)
    expect(find.text('Rp 15.000'), findsWidgets);
    expect(find.text('Checkout'), findsOneWidget);
  });

  testWidgets('Tapping + button increases quantity up to 20 limits', (WidgetTester tester) async {
    final controller = Get.find<CartController>();
    
    final product = ProductModel(
      id: 'prod-1',
      name: 'Roti Coklat',
      price: 10000,
      status: 'ACTIVE',
    );
    
    controller.addToCart(product);
    await tester.pumpWidget(createWidgetUnderTest());
    
    // Initial quantity is 1
    expect(find.text('1'), findsOneWidget);
    
    // Tap the + button
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump(); // Rebuild UI
    
    // Quantity should be 2
    expect(find.text('2'), findsOneWidget);
    expect(controller.totalQuantity, 2);
  });
}
