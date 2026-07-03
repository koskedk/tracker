import 'package:injectable/injectable.dart';
import 'package:tracker/application/projects/create_project_use_case.dart';
import 'package:tracker/core/seed/data_seeder.dart';
import 'package:tracker/domain/repositories/project_repository.dart';

@Environment('dev')
@LazySingleton(as: IDataSeeder)
class DevDataSeeder implements IDataSeeder {
  final IProjectRepository repository;
  final CreateProjectUseCase createProjectUseCase;

  DevDataSeeder(this.repository, this.createProjectUseCase);

  @override
  Future<void> seed() async {
    final existingProjects = await repository.getProjects();
    final hasProjects = existingProjects.fold(
      (failure) => false,
      (projects) => projects.isNotEmpty,
    );

    if (hasProjects) {
      return;
    }

    final projects = [
      {
        'name': 'County Hospital',
        'description': 'Hospital construction for the South',
      },
      {
        'name': 'Luke Dam',
        'description': 'Luke Dam Project for North Rift Valley',
      },
    ];

    for (var project in projects) {
      await createProjectUseCase(
        CreateProjectParams(
          name: project['name']!,
          description: project['description']!,
        ),
      );
    }
  }
}
