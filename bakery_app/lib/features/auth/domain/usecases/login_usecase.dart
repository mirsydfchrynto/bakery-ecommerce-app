import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<void> execute(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception('Username and password must not be empty');
    }
    return await repository.login(username, password);
  }
}
