import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'core/storage/secure_storage_helper.dart';
import 'core/network/api_client.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Environment Variables
  await dotenv.load(fileName: ".env");

  // Initialize Global Services
  await Get.putAsync(() => SecureStorageHelper().init());
  Get.put(ApiClient());

  runApp(const BakeryApp());
}

class BakeryApp extends StatelessWidget {
  const BakeryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          GetMaterialApp(
            title: 'Bakery App',
            theme: AppTheme.lightTheme,
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
            debugShowCheckedModeBanner: false,
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: Opacity(
              opacity: 0.0,
              child: Text(
                'developer_watermark: mirsydfchrynto',
                style: TextStyle(fontSize: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
