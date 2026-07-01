import 'package:drift/drift.dart';
import 'package:tracker/infrastructure/persistence/daos/project_dao.dart';
import 'package:tracker/infrastructure/persistence/tables/projects_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Projects], daos: [ProjectDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
