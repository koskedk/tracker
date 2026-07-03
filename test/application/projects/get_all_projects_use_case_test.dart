import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracker/application/projects/get_all_projects_use_case.dart';
import 'package:tracker/core/usecases/use_case.dart';
import 'package:tracker/domain/repositories/project_repository.dart';
import 'package:tracker/infrastructure/persistence/app_database.dart';
import 'package:tracker/infrastructure/persistence/daos/project_dao.dart';
import 'package:tracker/infrastructure/repositories/project_repository_impl.dart';

void main() {
  late AppDatabase database;
  late ProjectDao projectDao;
  late IProjectRepository projectRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    projectDao = ProjectDao(database);
    projectRepository = ProjectRepositoryImpl(projectDao);
  });
  test('should get all projects', () async {
    final useCase = GetAllProjectsUseCase(projectRepository);
    final result = await useCase(NoParams());
    expect(result.isRight(), true);
  });
}
