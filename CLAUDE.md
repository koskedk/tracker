# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                                              # install dependencies

# Code generation (freezed, drift, injectable, json_serializable) — required after
# editing any entity, table, DAO, DTO, or @injectable/@module class
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs     # regenerate on file save

flutter analyze                                               # static analysis (flutter_lints)

flutter test                                                  # run all tests (integration-tagged tests are skipped)
flutter test test/domain/entities/project_test.dart           # run a single test file
flutter test --plain-name "should create a project"           # run a single test by name

# tests tagged `integration` hit a real, running backend and are skipped by default (dart_test.yaml) —
# run them explicitly, pointing at whichever backend you want:
flutter test --tags=integration --run-skipped --dart-define-from-file=env/test.json

flutter run -d chrome                                         # run the app (web is the only configured platform — no android/ios/desktop dirs)
flutter run -d chrome --dart-define-from-file=env/dev.json    # run against a specific environment's config (see env/)
```

## Architecture

Layered/clean-architecture style, mirrored between `lib/` and `test/`:

- `lib/domain/` — entities (`@freezed`, e.g. `Project`) and repository interfaces (`IProjectRepository`). Pure Dart, no framework/persistence dependencies.
- `lib/application/` — use cases, one class per action (e.g. `CreateProjectUseCase`, `GetAllProjectsUseCase`), implementing `UseCase<T, Params>` (`lib/core/usecases/use_case.dart`). Use cases depend only on domain repository interfaces and are `@injectable`.
- `lib/infrastructure/` — implementations of domain interfaces:
  - `persistence/` — Drift (`drift` + `drift_flutter`) tables, generated `AppDatabase`, and DAOs.
  - `repositories/` — `*RepositoryImpl` classes implementing the domain repository interfaces, mapping between Drift row/companion classes and domain entities via private `_toDomain`/`_toCompanion` methods. Drift's generated row/companion classes serve as the local persistence layer's own data objects — there is intentionally no separate DTO between them and the domain entity.
  - `dtos/` — DTOs for remote/API data only (`@JsonSerializable`, `fromJson`/`toJson`, plus a `toDomain()` mapper). Kept separate from the Drift mapping above since local schema and remote API shape are independent and expected to diverge.
  - `datasources/` — remote data sources (e.g. `ProjectRemoteDataSource`) wrapping `Dio` calls and returning DTOs. Not yet wired into any repository — that composition (fetch/cache/merge policy) is decided per-feature when a real sync requirement exists.
  - `seed/` — `IDataSeeder` implementations (`DevDataSeeder`, `ProdDataSeeder`) registered per DI environment, seeding local data on app start.
- `lib/presentation/` — Riverpod (`flutter_riverpod`) providers/notifiers and widgets, one folder per feature (e.g. `projects/`). Notifiers pull use cases directly from `getIt` rather than through Riverpod DI.
- `lib/core/` — cross-cutting concerns:
  - `di/` — `injectable`/`get_it` setup. `injection.dart` exposes `configureDependencies()`; `@module` classes (`network_module.dart`, `database_module.dart`) provide third-party singletons (`Dio`, `AppDatabase`, DAOs); `injection.config.dart` is generated — never hand-edit it.
  - `errors/failures.dart` — sealed `Failure` class (`DatabaseFailure`, `NetworkFailure`, `UnknownFailure`).
  - `config/app_config.dart` — `AppConfig.baseUrl`, read from the `BASE_URL` dart-define. Per-environment values live in `env/{dev,prod,test}.json`, passed via `--dart-define-from-file` (built into the Flutter/Dart CLI, no extra package). `env/prod.json` currently holds a placeholder — replace with the real production URL before using it.
  - `usecases/use_case.dart` — shared `UseCase<T, Params>` abstraction and `NoParams`.
  - `seed/data_seeder.dart` — `IDataSeeder` interface.

**Error handling convention**: every repository/use-case method returns `Future<Either<Failure, T>>` (via `fpdart`) rather than throwing. `.fold((failure) => ..., (value) => ...)` at the call site (see `ProjectListNotifer` in `lib/presentation/projects/providers/project_list_provider.dart`).

**DI environments**: `main.dart` calls `configureDependencies(environment: kDebugMode ? 'dev' : 'prod')`; environment-scoped implementations are annotated `@Environment('dev')` / `@Environment('prod')` (e.g. the two `IDataSeeder` implementations).

**Testing conventions**: prefer a real dependency over a mock where a lightweight real one exists — repository tests use an in-memory Drift database (`NativeDatabase.memory()`) rather than mocking the DAO (`test/infrastructure/repositories/project_repository_impl_test.dart`). Where the real thing means real network I/O (Dio-based data sources), use `mocktail` to mock only `HttpClientAdapter` — Dio's transport interface — so the real `Dio` request/response/(de)serialization logic still runs (`test/infrastructure/datasources/project_remote_data_source_test.dart`). Tests that must hit an actually running backend are tagged `@Tags(['integration'])` and excluded by default via `dart_test.yaml`; run them explicitly per the command above.
