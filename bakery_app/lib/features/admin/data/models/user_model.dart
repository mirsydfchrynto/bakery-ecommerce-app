import '../../../../core/constants/app_config.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String role;
  final String? profilePictureUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.profilePictureUrl,
  });

  String? get displayProfileImageUrl {
    if (profilePictureUrl == null || profilePictureUrl!.isEmpty) return null;
    if (profilePictureUrl!.startsWith('http')) return profilePictureUrl;
    final hostUrl = AppConfig.baseUrl.replaceAll('/api/v1', '');
    return hostUrl + (profilePictureUrl!.startsWith('/') ? profilePictureUrl! : '/$profilePictureUrl');
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? 'CUSTOMER',
      profilePictureUrl: json['profilePictureUrl'],
    );
  }
}
