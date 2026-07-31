import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_remote_data_source.dart';
import '../../../../core/storage/secure_storage_helper.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageHelper secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  Future<void> login(String username, String password) async {
    final data = await remoteDataSource.login(username, password);
    final token = data['token'] as String;
    final refreshToken = data['refreshToken'] as String?;
    final role = data['user']['role'] as String;
    final uName = data['user']['username'] as String;
    final email = data['user']['email'] as String?;
    await secureStorage.saveToken(token);
    if (refreshToken != null) {
      await secureStorage.saveRefreshToken(refreshToken);
    }
    await secureStorage.saveRole(role);
    await secureStorage.saveUsername(uName);
    if (email != null) {
      await secureStorage.saveEmail(email);
    }
  }

  @override
  Future<void> register(String username, String email, String phone, String password) async {
    // Calling API, it returns 201 Created. You typically might log them in automatically
    // or just let them go to login page. We'll just execute it.
    await remoteDataSource.register(username, email, phone, password);
  }

  @override
  Future<void> logout() async {
    await secureStorage.clearAll();
  }

  @override
  Future<Map<String, dynamic>> getProfile() async {
    return await remoteDataSource.getProfile();
  }

  @override
  Future<Map<String, dynamic>> updateProfile(String username, String email, String phone, {String? profilePictureUrl}) async {
    final updatedData = await remoteDataSource.updateProfile(username, email, phone, profilePictureUrl: profilePictureUrl);
    await secureStorage.saveUsername(updatedData['username']);
    await secureStorage.saveEmail(updatedData['email']);
    return updatedData;
  }

  @override
  Future<String> uploadProfilePicture(String filePath) async {
    return await remoteDataSource.uploadProfilePicture(filePath);
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await remoteDataSource.changePassword(oldPassword, newPassword);
  }

  @override
  Future<void> deleteAccount() async {
    await remoteDataSource.deleteAccount();
    await secureStorage.clearAll();
  }

  @override
  Future<void> forgotPassword(String email) async {
    await remoteDataSource.forgotPassword(email);
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    await remoteDataSource.resetPassword(token, newPassword);
  }
}
