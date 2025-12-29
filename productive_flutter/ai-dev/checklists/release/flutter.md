# Release Checklist: Flutter

## Build & smoke

- `flutter pub get` succeeds.
- `flutter analyze` succeeds (or known warnings reviewed).
- Release build succeeds:
  - Android: `flutter build apk --release` or `flutter build appbundle --release`
  - iOS: `flutter build ios --release` (as applicable)
- App launches and critical flows work on at least one real device/simulator.

## Assets & config

- App icon/splash/branding unchanged unless intended.
- No hardcoded URLs; config/environment is correct.
- Firebase config files (if used) are correct per environment (dev/stage/prod).

## Permissions

- Any new permissions reviewed and justified.
- Permission prompts tested (happy + denial paths).
