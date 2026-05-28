## Structure

- `README.md` is still the default Flutter template; trust `pubspec.yaml` and the app wiring under `lib/` instead.
- This is a single Flutter app rooted at the repo root. The Dart package name is `flutter_app`, so local imports use `package:flutter_app/...`.
- App startup is `lib/main.dart` -> `lib/app/bootstrap.dart`; bootstrap configures web URL strategy, initializes `pt_BR` date formatting, wires dependencies, then runs `GlossipApp`.

## Runtime

- Runtime config is compile-time only via `--dart-define`. Supported `APP_FLAVOR` values are `local`, `staging`, and `prod`; `API_BASE_URL` overrides the flavor default in `lib/app/config/app_config.dart`.
- `local` and `staging` both default to `http://localhost:8080/`; `prod` defaults to `https://www.gossipuerj.com.br/`.
- Web routing uses `usePathUrlStrategy()` in `lib/app/platform/platform_setup.dart`; deploys need SPA rewrites for deep links to work.

## Architecture

- Dependency wiring is centralized in `lib/app/di/service_locator.dart` with `GetIt`.
- `SessionCubit` is a singleton started eagerly from `GlossipApp`; `AuthCubit` and `ProfileCubit` are factories.
- Only auth/profile currently talk to the backend through Dio repositories. Feed, crushes, messages, and events still run from in-memory cubits in `lib/shared/state/mock_app_cubits.dart`, seeded by `lib/shared/seed/mock_seed_data.dart`.
- Auth is magic-link based: login posts to `/api/v1/auth/login`, verify uses `/auth/verify?token=...`, and the token is stored in `SharedPreferences` under `session_token`.
- Router guards are narrow: unauthenticated users are redirected away from `/profile`, but `/`, `/crushes`, `/eventos`, and `/messages` are public unless you change `lib/app/router.dart`.

## Verification

- There is no checked-in CI workflow or task runner config; use Flutter commands directly.
- Main checks: `flutter analyze` and `flutter test`.
- Focused tests: `flutter test test/controllers_test.dart` and `flutter test test/widget_test.dart`.

## Guidelines

- For UI, visual design, or new component work: refer to `docs/design-identity.md` first and prefer the `Glossip*` components exported by `lib/shared/widgets/glossip_components.dart` over raw Material-styled UI.

## Graphify

- `.opencode/opencode.json` enables the graphify plugin.
- `graphify-out/` is not checked in right now; generate or update graph artifacts before relying on graph reports.
