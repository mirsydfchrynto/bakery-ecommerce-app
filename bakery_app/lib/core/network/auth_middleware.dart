import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../storage/secure_storage_helper.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Note: SecureStorageHelper caches token synchronously via init() on app start
    final storage = Get.find<SecureStorageHelper>();
    final isAuthenticated = storage.hasToken;
    final role = storage.currentRole;
    
    // Allow public routes
    if (route == Routes.login || route == Routes.register || route == Routes.initial || route == Routes.onboarding) {
      if (isAuthenticated) {
        // If already logged in, redirect to respective home
        if (role == 'ADMIN') return const RouteSettings(name: Routes.adminHome);
        return const RouteSettings(name: Routes.home);
      }
      return null; // let them access public routes
    }

    // Guard protected routes
    if (!isAuthenticated) {
      return const RouteSettings(name: Routes.login);
    }
    
    // Guard admin routes
    if (route != null && route.startsWith('/admin') && role != 'ADMIN') {
      return const RouteSettings(name: Routes.home);
    }

    return null;
  }
}
