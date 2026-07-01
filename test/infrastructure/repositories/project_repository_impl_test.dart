import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracker/domain/entities/project.dart';
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

  tearDown(() async {
    await database.close();
  });

  test('should create a project', () async {
    final p = Project.create(
      name: 'Test Project',
      description: 'Test Description',
    );
    final result = await projectRepository.createProject(p);
    expect(result.isRight(), true);
  });

  test('should get all projects', () async {
    final p = Project.create(
      name: 'New Project',
      description: 'New Test Description',
    );
    await projectRepository.createProject(p);

    final result = await projectRepository.getProjects();
    result.fold(
      (failiure) => fail('Expected success, got failure: $failiure'),
      (projects) {
        expect(projects.length, 1);
        expect(projects.first.name, 'New Project');
        expect(projects.first.description, 'New Test Description');
      },
    );
  });
}
