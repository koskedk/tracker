import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracker/application/projects/create_project_use_case.dart';
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

  test('create project use case ...', () async {
    final params = CreateProjectParams(
      name: 'Test Project',
      description: 'Test Description',
    );

    final useCase = CreateProjectUseCase(projectRepository);
    final result = await useCase(params);
    expect(result.isRight(), true);
  });
}
