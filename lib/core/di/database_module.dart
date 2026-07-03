import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:tracker/infrastructure/persistence/app_database.dart';
import 'package:tracker/infrastructure/persistence/daos/project_dao.dart';

@module
abstract class DatabaseModule {
  @lazySingleton
  AppDatabase get database => AppDatabase(driftDatabase(
        name: 'tracker',
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
        native: const DriftNativeOptions(),
      ));

  @lazySingleton
  ProjectDao projectDao(AppDatabase database) => ProjectDao(database);
}
