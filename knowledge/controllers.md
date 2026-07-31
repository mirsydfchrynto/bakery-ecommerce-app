# Controllers Knowledge Base

## `AuthController.kt` (Backend)
- **Role**: Entry point for IAM operations.
- **Dependencies**: `AuthService`.
- **Endpoints**:
  - `POST /api/v1/auth/login`: Handles user login. Requires `LoginRequest`. Returns `BaseResponse<AuthResponse>`.
  - `POST /api/v1/auth/register`: Handles user registration. Requires `@Valid RegisterRequest`. Returns `BaseResponse<AuthResponse>` (201 Created).
- **Business Rules**:
  - Validates `RegisterRequest` formats automatically via Jakarta `@Valid` before reaching the service layer.
- **Evidence**: Source code (`/home/irsyad/bakery_project/backend/src/main/kotlin/com/bakery/ecommerce/domain/iam/controller/AuthController.kt`).
- **Confidence**: High.


## Catalog Module (Backend)
- **Controller**: `ProductController`
- **Endpoints**:
  - `GET /api/v1/products` (Public) - Retrieves ACTIVE products only.
  - `GET /api/v1/products/admin` (Admin) - Retrieves all products (including DRAFT/ARCHIVED). Requires `ROLE_ADMIN`.
  - `POST /api/v1/products/admin` (Admin) - Creates a new product. Initializes Inventory stock to 100 automatically.
  - `PUT /api/v1/products/admin/{id}` (Admin) - Updates product details and optionally sets a new primary `ProductImage`.
  - `DELETE /api/v1/products/admin/{id}` (Admin) - Soft deletes the product (sets `status` to ARCHIVED and `isDeleted = true`).
- **Data Transfer**:
  - `ProductDto` returns `id`, `name`, `description`, `price`, `status`, `imageUrl` (primary image), `categoryName`.
  - `CreateProductRequest` & `UpdateProductRequest`.
- **Evidence**: Extracted from `ProductController.kt`, `ProductDtos.kt`.



## Order Module (Backend)
- **Controller**: `OrderController`
- **Endpoints**:
  - `POST /api/v1/orders` (Customer) - Submits checkout. Evaluates user from `@AuthenticationPrincipal`.
  - `GET /api/v1/orders` (Customer) - Fetches their own orders.
  - `GET /api/v1/orders/admin` (Admin) - Fetches all orders.
  - `PUT /api/v1/orders/admin/{orderId}/status` (Admin) - Updates order status.
- **Business Rules**:
  - Order Checkout: Verifies product is `ACTIVE`. Verifies `availableStock >= quantity`. Sets status to `WAITING_PAYMENT`. Reserves inventory (`reservedStock += quantity`) using `PESSIMISTIC_WRITE` lock. Stores order items and saves snapshot to `orderAddressRepository`.
  - Status Transitions:
    - `COMPLETED`: Subtracts both `stock` and `reservedStock`.
    - `CANCELLED`, `PAYMENT_REJECTED`, `EXPIRED`: Decrements `reservedStock` only, returning it to available pool.



## Payment Module (Backend)
- **Controller**: `PaymentController`
- **Endpoints**:
  - `POST /api/v1/payments/{orderId}/upload` (Customer) - Accepts `multipart/form-data`. Saves files locally to `uploads/` directory. Creates/Updates `Payment` to `VERIFYING`. Updates `Order` status to `VERIFYING_PAYMENT`.
  - `GET /api/v1/payments/admin/{orderId}` (Admin) - Fetches payment details.
- **Service**: `AdminPaymentService`
- **Business Rules**:
  - Approve Payment: Payment becomes `APPROVED`, Order becomes `PROCESSING`. Performs the final physical inventory deduction (`stock -= quantity`, `reservedStock -= quantity`). Publishes `AuditEvent` (APPROVE_PAYMENT).
  - Reject Payment: Payment becomes `REJECTED`, Order becomes `PAYMENT_REJECTED`. Releases reserved inventory (`reservedStock -= quantity`). Publishes `AuditEvent` (REJECT_PAYMENT).



## Admin Module (Backend)
- **Controller**: `AdminPaymentController`
- **Endpoints**:
  - `POST /api/v1/admin/payments/{id}/approve`
  - `POST /api/v1/admin/payments/{id}/reject`
- **Business Rules**:
  - Disconnect Alert: The frontend `AdminOrdersController` does NOT invoke these endpoints when verifying payments. Instead, it directly uses the `OrderController` endpoint (`PUT /orders/admin/{id}/status`) to change status to PROCESSING. This means the `AuditEvent` and early stock deductions in `AdminPaymentService` are entirely bypassed by the current frontend implementation!

