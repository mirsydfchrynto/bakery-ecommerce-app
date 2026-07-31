import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bakery_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:bakery_app/features/auth/domain/usecases/login_usecase.dart';
import 'login_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  test('should call repository login when username and password are provided', () async {
    // arrange
    when(mockRepository.login(any, any)).thenAnswer((_) async {});
    
    // act
    await useCase.execute('testuser', 'password123');
    
    // assert
    verify(mockRepository.login('testuser', 'password123'));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw exception when username is empty', () async {
    // act & assert
    expect(() => useCase.execute('', 'password123'), throwsException);
    verifyZeroInteractions(mockRepository);
  });
}
