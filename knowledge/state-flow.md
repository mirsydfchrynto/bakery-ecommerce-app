# State Flow Knowledge Base

## Authentication State Flow (Flutter GetX)
1. **App Start**: `SplashScreen` waits 2500ms, calls `SecureStorageHelper.getToken()`. If exists -> routes to home/admin based on role. If null -> `/onboarding`.
2. **Onboarding**: Carousel of 3 images. Last image 'Forward' action triggers `Get.offAllNamed('/login')`.
3. **Login Form**:
   - `usernameCtrl` and `passwordCtrl` bind to text fields.
   - On 'Sign In', triggers `controller.login(username, password)`.
   - `AuthController` state transitions: `RxStatus.loading()` -> API Call -> `RxStatus.success()` or `RxStatus.error()`.
   - On success, `SecureStorageHelper` saves `jwt_token`, `user_role`, `username`. Then navigates to home.
4. **Registration Form**:
   - 4 controllers (username, email, phone, password).
   - Local validation (empty check, `GetUtils.isEmail`, `GetUtils.isPhoneNumber`, length checks).
   - On 'Sign Up', triggers `controller.register(...)`.
   - State transition: `loading()` -> API Call -> `success()`. 
   - On success, redirects back to `/login` with a success snackbar.

## Evidence
- Code analysis of `auth_controller.dart`, `splash_screen.dart`, `login_screen.dart`, `register_screen.dart`.
- **Confidence**: High.


## Catalog State Flow (Frontend)
1. **App Initialization**: `CatalogController` fetches products on `onInit()` via `GetProductsUseCase`.
2. **UI Subscription**: Both `HomeScreen` and `MenuScreen` listen to `controller.obx()`.
3. **Filtering**: Done locally on the frontend. The `products` list from controller is filtered by `_searchQuery` and `_selectedCategory`.
4. **Main Screen Navigation**: `MainScreen` manages `_currentIndex` for an `IndexedStack`.



## Order State Flow (Frontend)
1. **Adding to Cart**: `CartController.addToCart(ProductModel)` updates the observable map.
2. **Checkout**: 
   - `CartController.checkout()` converts map values to payload.
   - Shows loading dialog.
   - Invokes API.
   - On success: clears cart, closes dialog, routes to `/order-history`.
3. **Order History**: `OrderHistoryController` fetches orders on `onInit()`. Updates `RxStatus`.
4. **Payment Intent**: Clicking "Pay Now" on a `WAITING_PAYMENT` order routes to `/payment` passing the order object as `arguments`.



## Payment State Flow (Frontend)
1. **Selecting Images**: User can pick up to 5 images using `image_picker`. Displayed in a grid.
2. **Submitting Proof**: User confirms payment. Sends `multipart/form-data` with images and payment info (bankName, accountName, transferAmount).
3. **Completion**: Restarts the user journey to Home screen upon success.



## Splash & Onboarding (Frontend)
- **Splash Screen**: Evaluates Auth Token & Role natively using `SecureStorageHelper`.
  - Transitions to `/admin-home` if `ROLE_ADMIN`.
  - Transitions to `/home` if `ROLE_CUSTOMER`.
  - Defaults to `/onboarding` if unauthorized.
- **Onboarding Screen**: Static premium UI mapping directly to `/login`.

