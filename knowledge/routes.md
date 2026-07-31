# Routes Knowledge Base

## Authentication Routes (Flutter GetX)
- **`/` (Initial)**: Routes to `SplashScreen`. Determines next route based on token/role.
- **`/onboarding`**: Routes to `OnboardingScreen`. Ends by pushing to `/login`.
- **`/login`**: Routes to `LoginScreen` bound with `AuthBinding`.
- **`/register`**: Routes to `RegisterScreen` bound with `AuthBinding`.

## Redirection Logic
- If `ROLE_ADMIN` -> `/admin-home`
- If `ROLE_CUSTOMER` (or not admin) -> `/home`

## Evidence
- Extracted from `app_pages.dart`, `splash_screen.dart`, `auth_controller.dart`.
- **Confidence**: High.
