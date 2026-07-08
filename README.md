# Tracker

A project tracker companion for Idadi, built with Flutter.

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

The app currently targets the web only (no `android/`, `ios/`, or desktop platform folders are configured).

Per-environment config lives in `env/` (`dev.json`, `prod.json`, `test.json`), each defining `BASE_URL`. Pass the relevant file with `--dart-define-from-file`:

```bash
flutter run -d chrome --dart-define-from-file=env/dev.json
```

`env/prod.json` currently holds a placeholder URL — replace it with the real production API address before using it. To override a single value ad hoc instead of using a file, `--dart-define=BASE_URL=...` still works.

## Development

Regenerate code after editing any entity, Drift table/DAO, DTO, or `@injectable`/`@module` class:

```bash
dart run build_runner build --delete-conflicting-outputs
# or, to regenerate on every save:
dart run build_runner watch --delete-conflicting-outputs
```

Run static analysis and tests:

```bash
flutter analyze
flutter test
```

Tests that require a real, running backend are tagged `integration` and skipped by default. Run them explicitly against whichever backend you want:

```bash
flutter test --tags=integration --run-skipped --dart-define-from-file=env/test.json
```

## Architecture

The codebase follows a layered/clean-architecture style:

- **`lib/domain/`** — entities and repository interfaces. Pure Dart, no framework dependencies.
- **`lib/application/`** — use cases (one class per action) that depend only on domain repository interfaces.
- **`lib/infrastructure/`** — implementations: local persistence (Drift), remote data sources and DTOs, repository implementations, and data seeders.
- **`lib/presentation/`** — Riverpod providers/notifiers and widgets, one folder per feature.
- **`lib/core/`** — dependency injection setup, error types, app configuration, and shared abstractions.

Every repository/use-case method returns `Future<Either<Failure, T>>` (via `fpdart`) instead of throwing, so failures are handled explicitly at each call site.

See [CLAUDE.md](CLAUDE.md) for a more detailed architecture breakdown and the full set of development commands.
