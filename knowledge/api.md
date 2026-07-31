# API Knowledge Base

## Authentication API (`/api/v1/auth`)

### `POST /login`
- **Request Body**: `{"username": "...", "password": "..."}`
- **Response (200)**: `{"success": true, "message": "Login successful", "data": {"token": "...", "user": {"id": "...", "username": "...", "email": "...", "phoneNumber": "...", "role": "..."}}}`
- **Errors**: 401 Unauthorized (`AUTH-002`) for invalid credentials.

### `POST /register`
- **Request Body**: `{"username": "...", "email": "...", "phoneNumber": "...", "password": "..."}`
- **Response (201)**: `{"success": true, "message": "Registration successful", "data": {...}}`
- **Errors**: 
  - 400 Bad Request (Validation errors on `@Email`, `@Pattern`, `@NotBlank`)
  - 400 Bad Request (Duplicate values: `AUTH-001`, `AUTH-003`, `AUTH-004`)
- **Evidence**: `AuthController.kt`, `AuthDtos.kt`, `AuthRemoteDataSource.dart`.
- **Confidence**: High.


## Catalog API (`/api/v1/products`)
### `GET /`
- **Response**: List of `ProductDto` where status = ACTIVE.

### `GET /admin`
- **Authorization**: Requires `ROLE_ADMIN`
- **Response**: List of all `ProductDto`.

### `POST /admin`
- **Authorization**: Requires `ROLE_ADMIN`
- **Request Body**: `CreateProductRequest` (`name`, `description`, `price`, `imageUrl`)
- **Response**: Created `ProductDto`.

### `PUT /admin/{id}`
- **Authorization**: Requires `ROLE_ADMIN`
- **Request Body**: `UpdateProductRequest`
- **Response**: Updated `ProductDto`.

### `DELETE /admin/{id}`
- **Authorization**: Requires `ROLE_ADMIN`
- **Response**: Success message (Soft Delete).

