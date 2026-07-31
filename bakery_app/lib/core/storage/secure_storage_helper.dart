import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStorageHelper extends GetxService {
  late FlutterSecureStorage _storage;
  String? _cachedToken;
  String? _cachedRole;

  Future<SecureStorageHelper> init() async {
    _storage = const FlutterSecureStorage();
    _cachedToken = await _storage.read(key: 'jwt_token');
    _cachedRole = await _storage.read(key: 'user_role');
    return this;
  }

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    _cachedToken = await _storage.read(key: 'jwt_token');
    return _cachedToken;
  }

  bool get hasToken => _cachedToken != null && _cachedToken!.isNotEmpty;
  String? get currentRole => _cachedRole;

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'jwt_refresh_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'jwt_refresh_token');
  }

  Future<void> saveRole(String role) async {
    _cachedRole = role;
    await _storage.write(key: 'user_role', value: role);
  }

  Future<String?> getRole() async {
    return await _storage.read(key: 'user_role');
  }

  Future<void> saveUsername(String username) async {
    await _storage.write(key: 'username', value: username);
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }

  Future<void> saveEmail(String email) async {
    await _storage.write(key: 'user_email', value: email);
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: 'user_email');
  }

  Future<void> clearAll() async {
    _cachedToken = null;
    _cachedRole = null;
    await _storage.deleteAll();
  }
}
