# Business Rules Knowledge Base

## Authentication Module
- **Login**:
  - Username and password must not be empty.
  - Matches password hashes via `PasswordEncoder` (BCrypt).
  - Issues JWT containing `userId` and `roleName`.
  - Frontend routes users to `/admin-home` if `ROLE_ADMIN`, otherwise `/home`.
- **Registration**:
  - Email, Phone Number, Username, Password are required.
  - Frontend checks regex format for Email and Phone before API call.
  - Backend rejects duplicates for `username` (AUTH-001), `email` (AUTH-003), and `phoneNumber` (AUTH-004).
  - All newly registered users default to the `CUSTOMER` role.
- **Evidence**: Source code (`AuthService.kt`, `register_screen.dart`, `LoginUseCase.dart`, `RegisterUseCase.dart`).
- **Confidence**: High.


## Catalog Module
- **Cross-module Interaction**: Creating a product (`ProductService.createProduct`) directly initializes an `Inventory` record for the product with default stock = 100, `reservedStock` = 0, `minimumStock` = 5.
- **Data aggregation**: Product fetching aggregates primary `ProductImage` URL and the first mapped `Category` name into `ProductDto`.



## Inventory Module (Backend)
- **Architecture**: No explicit service. Embedded directly within `OrderService` and `AdminPaymentService`.
- **Business Rules**:
  - `PESSIMISTIC_WRITE` lock (`FOR UPDATE`) is used via `InventoryRepository.findByProductIdForUpdate`.
  - Avoids race conditions during checkout and payment approval.
  - `stock` is the physical limit, `reservedStock` is the pending limit. `Available = stock - reservedStock`.

