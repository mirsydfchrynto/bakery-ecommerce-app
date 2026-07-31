import 'package:get/get.dart';
import '../core/network/auth_middleware.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/auth/bindings/auth_binding.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/catalog/presentation/screens/main_screen.dart';
import '../features/catalog/bindings/home_binding.dart';
import '../features/order/presentation/screens/order_history_screen.dart';
import '../features/order/bindings/order_history_binding.dart';
import '../features/admin/presentation/screens/admin_home_screen.dart';
import '../features/admin/presentation/screens/admin_orders_screen.dart';
import '../features/admin/bindings/admin_orders_binding.dart';
import '../features/admin/presentation/screens/admin_products_screen.dart';
import '../features/admin/bindings/admin_products_binding.dart';
import '../features/admin/presentation/screens/admin_customers_screen.dart';
import '../features/admin/presentation/bindings/admin_customers_binding.dart';
import '../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../features/admin/bindings/admin_dashboard_binding.dart';
import '../features/payment/presentation/screens/payment_screen.dart';
import '../features/payment/bindings/payment_binding.dart';
import '../features/order/presentation/screens/cart_screen.dart';

abstract class Routes {
  static const initial = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const orderHistory = '/order-history';
  static const adminHome = '/admin-home';
  static const adminOrders = '/admin-orders';
  static const adminProducts = '/admin-products';
  static const adminCustomers = '/admin-customers';
  static const adminDashboard = '/admin-dashboard';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
}

class AppPages {
  static const initial = Routes.initial;

  static final routes = [
    GetPage(
      name: Routes.initial,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const MainScreen(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.orderHistory,
      page: () => const OrderHistoryScreen(),
      middlewares: [AuthMiddleware()],
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: Routes.adminHome,
      page: () => const AdminHomeScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.adminOrders,
      page: () => const AdminOrdersScreen(),
      middlewares: [AuthMiddleware()],
      binding: AdminOrdersBinding(),
    ),
    GetPage(
      name: Routes.adminProducts,
      page: () => const AdminProductsScreen(),
      middlewares: [AuthMiddleware()],
      binding: AdminProductsBinding(),
    ),
    GetPage(
      name: Routes.adminCustomers,
      page: () => const AdminCustomersScreen(),
      middlewares: [AuthMiddleware()],
      binding: AdminCustomersBinding(),
    ),
    GetPage(
      name: Routes.adminDashboard,
      page: () => const AdminDashboardScreen(),
      middlewares: [AuthMiddleware()],
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: '/payment',
      page: () => const PaymentScreen(),
      middlewares: [AuthMiddleware()],
      binding: PaymentBinding(),
    ),
    GetPage(
      name: '/cart',
      page: () => const CartScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => const ResetPasswordScreen(),
      binding: AuthBinding(),
    ),
  ];
}
