import 'package:drift/drift.dart';
import 'package:tracker/infrastructure/persistence/app_database.dart';
import 'package:tracker/infrastructure/persistence/tables/projects_tables.dart';

part 'project_dao.g.dart';

@DriftAccessor(tables: [Projects])
class ProjectDao extends DatabaseAccessor<AppDatabase> with _$ProjectDaoMixin {
  ProjectDao(super.db);
  Future<List<ProjectRow>> getAllProjects() => select(projects).get();
  Future<int> insertProject(ProjectsCompanion project) =>
      into(projects).insert(project);
}
