# Repositories Knowledge Base

## `UserRepository.kt` (Backend)
- **Role**: Data access layer for `User` entity.
- **Dependencies**: Spring Data JPA `BaseRepository<User>`.
- **Methods**:
  - `findByUsername(username: String): User?`
  - `existsByUsername(username: String): Boolean`
  - `existsByEmail(email: String): Boolean`
  - `existsByPhoneNumber(phoneNumber: String): Boolean`
- **Business Rules**: Filters softly deleted users by default (`@SQLRestriction("is_deleted = false")` on `User` entity).
- **Evidence**: Source code (`User.kt`).
- **Confidence**: High.
