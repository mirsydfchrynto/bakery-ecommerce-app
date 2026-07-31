abstract class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> register(String username, String email, String phone, String password);
  Future<void> logout();
  Future<Map<String, dynamic>> getProfile();
  Future<Map<String, dynamic>> updateProfile(String username, String email, String phone, {String? profilePictureUrl});
  Future<String> uploadProfilePicture(String filePath);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> deleteAccount();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
}
