import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracker/application/projects/create_project_use_case.dart';
import 'package:tracker/core/seed/data_seeder.dart';
import 'package:tracker/domain/entities/project.dart';
import 'package:tracker/domain/repositories/project_repository.dart';
import 'package:tracker/infrastructure/persistence/app_database.dart';
import 'package:tracker/infrastructure/persistence/daos/project_dao.dart';
import 'package:tracker/infrastructure/repositories/project_repository_impl.dart';
import 'package:tracker/infrastructure/seed/dev_data_seeder.dart';

void main() {
  late AppDatabase database;
  late ProjectDao projectDao;
  late IProjectRepository projectRepository;
  late CreateProjectUseCase createProjectUseCase;
  late IDataSeeder dataSeeder;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    projectDao = ProjectDao(database);
    projectRepository = ProjectRepositoryImpl(projectDao);
    createProjectUseCase = CreateProjectUseCase(projectRepository);
    dataSeeder = DevDataSeeder(projectRepository, createProjectUseCase);
  });

  testWidgets('dev data seeder ...', (tester) async {
    await dataSeeder.seed();

    final result = await projectRepository.getProjects();
    result.fold(
      (failiure) => fail('Expected success, got failure: $failiure'),
      (projects) {
        expect(projects.isNotEmpty, true);
      },
    );
  });
}
