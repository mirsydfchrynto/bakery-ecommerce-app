import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> register(String username, String email, String phone, String password);
  Future<Map<String, dynamic>> getProfile();
  Future<Map<String, dynamic>> updateProfile(String username, String email, String phone, {String? profilePictureUrl});
  Future<String> uploadProfilePicture(String filePath);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> deleteAccount();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await dio.post('/auth/login', data: {
      'identifier': username,
      'password': password,
    });
    
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw Exception(response.data['message'] ?? 'Login failed');
    }
  }

  @override
  Future<Map<String, dynamic>> register(String username, String email, String phone, String password) async {
    final response = await dio.post('/auth/register', data: {
      'username': username,
      'email': email,
      'phoneNumber': phone,
      'password': password,
    });
    
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw Exception(response.data['message'] ?? 'Registration failed');
    }
  }

  @override
  Future<Map<String, dynamic>> getProfile() async {
    final response = await dio.get('/users/me');
    if (response.data['success'] == true) {
      return response.data['data'];
    }
    throw Exception(response.data['message'] ?? 'Failed to load profile');
  }

  @override
  Future<Map<String, dynamic>> updateProfile(String username, String email, String phone, {String? profilePictureUrl}) async {
    final response = await dio.put('/users/me', data: {
      'username': username,
      'email': email,
      'phoneNumber': phone,
      // ignore: use_null_aware_elements
      if (profilePictureUrl != null) 'profilePictureUrl': profilePictureUrl,
    });
    if (response.data['success'] == true) {
      return response.data['data'];
    }
    throw Exception(response.data['message'] ?? 'Failed to update profile');
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    final response = await dio.post('/users/me/password', data: {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to change password');
    }
  }

  @override
  Future<void> deleteAccount() async {
    final response = await dio.delete('/users/me');
    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to delete account');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    final response = await dio.post('/auth/forgot-password', data: {'email': email});
    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to request password reset');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    final response = await dio.post('/auth/reset-password', data: {
      'token': token,
      'newPassword': newPassword,
    });
    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to reset password');
    }
  }

  @override
  Future<String> uploadProfilePicture(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await dio.post('/storage/upload', data: formData);
    if (response.statusCode == 200 && response.data['success'] == true) {
      return response.data['data']['url'];
    }
    throw Exception('Failed to upload image');
  }
}
