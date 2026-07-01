import 'dart:io';

import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tracker/infrastructure/persistence/app_database.dart';
import 'package:tracker/infrastructure/persistence/daos/project_dao.dart';

@module
abstract class DatabaseModule {
  @lazySingleton
  @preResolve
  Future<AppDatabase> get database async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'tracker.sqlite'));
    final db = AppDatabase(NativeDatabase.createInBackground(file));
    return db;
  }

  @lazySingleton
  ProjectDao projectDao(AppDatabase database) => ProjectDao(database);
}
