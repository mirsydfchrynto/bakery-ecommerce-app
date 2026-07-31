# Dependency Graph Knowledge Base

## Authentication Dependency Graph (Flutter)
`AuthBinding` resolves dependencies as follows:
- `ApiClient` (from core) -> `Dio`
- `AuthRemoteDataSourceImpl` requires `Dio`
- `SecureStorageHelper` (from core)
- `AuthRepositoryImpl` requires `AuthRemoteDataSource` & `SecureStorageHelper`
- `LoginUseCase` requires `AuthRepositoryImpl`
- `RegisterUseCase` requires `AuthRepositoryImpl`
- `AuthController` requires `LoginUseCase` & `RegisterUseCase`

## Evidence
- Extracted from `auth_binding.dart`.
- **Confidence**: High.
