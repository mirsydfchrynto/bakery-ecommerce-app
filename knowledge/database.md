# Database Knowledge Base

## Authentication & IAM Schema
- **Tables**: `users`, `roles`
- **`roles` Table**:
  - `id` (VARCHAR 36), `role_name` (UNIQUE), `description`
- **`users` Table**:
  - `id` (VARCHAR 36)
  - `role_id` (FK to roles)
  - `username` (VARCHAR 50, Indexed)
  - `password_hash` (VARCHAR 255)
  - `email` (VARCHAR 100)
  - `phone_number` (VARCHAR 20)
  - Soft delete fields: `is_deleted`, `deleted_at`
- **Constraints**: 
  - Unique username checked by backend logic.
  - Foreign key `fk_users_role`.
- **Migrations**: `V1__init_schema.sql` (base), `V2__add_user_details.sql` (email, phone).
- **Evidence**: `User.kt`, `V1__init_schema.sql`, `V2__add_user_details.sql`.
- **Confidence**: High.


## Catalog Schema
- **Tables**: `products`, `categories`, `product_categories`, `product_images`
- **`products` Table**: `id`, `name`, `description`, `price`, `status` (ACTIVE, DRAFT, ARCHIVED), `is_deleted`, `deleted_at`.
- **`categories` Table**: `id`, `name` (unique), `slug` (unique).
- **`product_images` Table**: Holds images for products. One image can be `isPrimary = true`.
- **Relations**: 
  - ManyToMany between `products` and `categories` via `product_categories`.
- **Constraints**: 
  - `@SQLRestriction("is_deleted = false")` on `Product`.



## Order Schema
- **Tables**: `orders`, `order_items`, `order_addresses`
- **`orders` Table**: `id`, `customer_id` (FK User), `total_amount`, `status` (DRAFT, PENDING, WAITING_PAYMENT, VERIFYING_PAYMENT, PROCESSING, COMPLETED, PAYMENT_REJECTED, CANCELLED, EXPIRED), `ordered_at`.
- **`order_items` Table**: `id`, `order_id` (FK Order), `product_id` (FK Product), `quantity`, `price_at_purchase`.
- **`order_addresses` Table**: Saves snapshot of address for the order (`recipient_name`, `phone_number`, `full_address`, `latitude`, `longitude`).



## Payment Schema
- **Table**: `payments`
- **Fields**: `id`, `order_id` (OneToOne), `payment_reference`, `payment_method`, `bank_name`, `account_name`, `transfer_amount`, `payment_proof_urls` (JSON array of relative paths), `payment_status` (PENDING, VERIFYING, APPROVED, REJECTED), `rejection_reason`, `verified_by` (FK User), `verified_at`.



## Additional Schemas
- **Table**: `inventories` (`id`, `product_id`, `stock`, `reserved_stock`, `minimum_stock`, `status`)
- **Table**: `audit_logs` (`id`, `actor`, `action`, `resource`, `entity_id`, `old_value`, `new_value`, `ip_address`, `device`, `timestamp`)

