import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint('.env file not found. Falling back to default configuration.');
    }
  }

  static String get baseUrl {
    return dotenv.env['BASE_URL'] ?? 'http://192.168.100.70:8080/api/v1'; 
  }
}
