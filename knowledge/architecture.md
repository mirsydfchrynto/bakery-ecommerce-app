# Architecture Knowledge Base

## Authentication Module
- **Frontend Architecture**: Flutter using GetX (StateMixin, Bindings, Dependency Injection). Implements Clean Architecture with layers: Presentation (`AuthController`, `LoginScreen`), Domain (`LoginUseCase`, `AuthRepository`), Data (`AuthRepositoryImpl`, `AuthRemoteDataSource`).
- **Backend Architecture**: Spring Boot (Kotlin) using layered architecture: Controller (`AuthController`), Service (`AuthService`), Repository (`UserRepository`), Entity (`User`).
- **Security**: JWT-based stateless authentication. Flutter stores JWT securely via `flutter_secure_storage`.
- **Evidence**: Extracted from folder structures and file dependencies across `/features/auth` and `/domain/iam`.
- **Confidence**: High.


## Catalog Module (Frontend)
- **Architecture**: Clean Architecture. `CatalogController` (StateMixin) -> `GetProductsUseCase` -> `CatalogRepositoryImpl` -> `CatalogRemoteDataSourceImpl`.
- **UI State**: `home_screen.dart` and `menu_screen.dart` observe `CatalogController` via `controller.obx()`. They implement local filtering (search string + category name).
- **Navigation**: `main_screen.dart` uses `IndexedStack` to switch between Home(0), Menu(1), Cart(2), Profile(3).
- **Business Rules**: `home_screen.dart` takes only 4 products when no search is active ("Popular Now"). `menu_screen.dart` displays responsive grid.
- **Data Model**: `ProductModel` (id, name, description, price, status, imageUrl, categoryName).
- **API mapping**: `CatalogRemoteDataSourceImpl` calls `GET /products` and expects `success: true` and `data: [...]`.
- **Evidence**: Extracted from `catalog_controller.dart`, `home_screen.dart`, `main_screen.dart`, `catalog_remote_data_source.dart`.



## Order Module (Frontend)
- **Architecture**: `CartController` manages in-memory `Map<String, CartItem>.obs`. It triggers `CheckoutUseCase` -> `OrderRepositoryImpl` -> `OrderRemoteDataSourceImpl`.
- **UI State**: `CartScreen` reads `CartController`. `OrderHistoryScreen` reads `OrderHistoryController` which uses `GetMyOrdersUseCase`.
- **Navigation**: `CartController.checkout()` automatically redirects to `/order-history` upon success.
- **Business Rules**:
  - Empty cart cannot checkout.
  - Cart injects dummy shipping address (Budi Santoso, Sudirman).
  - In `OrderHistoryScreen`, if order status is `WAITING_PAYMENT` or `PENDING`, a "Pay Now" button is displayed mapping to `/payment` with order arguments.
- **Evidence**: Extracted from `cart_controller.dart`, `order_history_screen.dart`, `order_history_controller.dart`.



## Payment Module (Frontend)
- **Architecture**: `PaymentController` manages up to 5 selected screenshot images (`XFile`) via `ImagePicker`. Submits via `PaymentRemoteDataSourceImpl` using `Dio` `FormData` (Multipart request).
- **UI State**: User views payment instructions and a grid of picked images.
- **Navigation**: On successful upload, `Get.offNamedUntil(/home, (route) => false)` resets the navigation stack back to home.
- **Evidence**: Extracted from `payment_controller.dart`, `payment_screen.dart`, `payment_remote_data_source.dart`.



## Admin Module (Frontend)
- **Architecture**: `AdminHomeScreen` serves as dashboard. Uses `AdminOrdersController` and `AdminProductsController` to manage domains.
- **Business Rules**:
  - **Orders**: Admin can update order status directly (PROCESSING, COMPLETED, CANCELLED). Can view payment proof which fetches from `/payments/admin/{orderId}` and displays images in a dialog. "Verify & Accept" button blindly updates order status to `PROCESSING`.
  - **Catalog**: Complete CRUD capabilities for products. Add/Edit via a BottomSheet dialog.
- **Evidence**: Extracted from `admin_orders_controller.dart`, `admin_products_controller.dart`.



## System Module (Backend)
- **Architecture**: Decoupled async event listening via Spring `@EventListener` and `@Async`.
- **Business Rules**:
  - `AuditEventListener` listens to `AuditEvent` published by `AdminPaymentService`.
  - Saves to `audit_logs` asynchronously without blocking the main transaction.

