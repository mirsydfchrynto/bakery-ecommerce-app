# Services Knowledge Base

## `AuthService.kt` (Backend)
- **Role**: Core business logic for authentication and registration.
- **Dependencies**: `UserRepository`, `RoleRepository`, `PasswordEncoder`, `JwtTokenProvider`.
- **Public Methods**:
  - `register(request: RegisterRequest): AuthResponse`: Handles user creation.
  - `login(request: LoginRequest): AuthResponse`: Handles authentication.
- **Business Rules**:
  - Registration rejects duplicate `username` (AUTH-001), `email` (AUTH-003), and `phoneNumber` (AUTH-004).
  - New users are assigned the `CUSTOMER` role. If it doesn't exist, it creates the role.
  - Login verifies password hashes and issues a JWT token.
- **Evidence**: Source code (`/home/irsyad/bakery_project/backend/src/main/kotlin/com/bakery/ecommerce/domain/iam/service/AuthService.kt`).
- **Confidence**: High.
