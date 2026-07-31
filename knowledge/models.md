# Models & DTOs Knowledge Base

## `AuthDtos.kt` (Backend)
- **LoginRequest**: `username`, `password`.
- **RegisterRequest**: 
  - `username` (@NotBlank)
  - `email` (@NotBlank, @Email)
  - `phoneNumber` (@NotBlank, @Pattern regex `^\+?[0-9]{10,15}$`)
  - `password` (@NotBlank)
- **UserDto**: `id`, `username`, `email`, `phoneNumber`, `role`.
- **AuthResponse**: `token`, `user: UserDto`.

## `User.kt` (Backend)
- **Entity**: `users` table.
- **Fields**: `username`, `passwordHash`, `email`, `phoneNumber`, `isDeleted`, `deletedAt`, `role` (ManyToOne to `Role`).
- **Evidence**: Source code (`AuthDtos.kt`, `User.kt`).
- **Confidence**: High.
