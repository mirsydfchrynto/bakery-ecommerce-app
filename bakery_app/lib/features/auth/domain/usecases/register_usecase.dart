import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> execute(String username, String email, String phone, String password) async {
    if (username.isEmpty || password.isEmpty || email.isEmpty || phone.isEmpty) {
      throw Exception('All fields must not be empty');
    }
    return await repository.register(username, email, phone, password);
  }
}
