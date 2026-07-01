import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:tracker/core/errors/failures.dart';
import 'package:tracker/core/usecases/use_case.dart';
import 'package:tracker/domain/entities/project.dart';
import 'package:tracker/domain/repositories/project_repository.dart';

class CreateProjectParams {
  final String name;
  final String? description;
  const CreateProjectParams({required this.name, this.description});
}

@injectable
class CreateProjectUseCase implements UseCase<Project, CreateProjectParams> {
  final IProjectRepository projectRepository;
  const CreateProjectUseCase(this.projectRepository);

  @override
  Future<Either<Failure, Project>> call(CreateProjectParams params) async {
    final p = Project.create(
      name: params.name,
      description: params.description,
    );
    return (await projectRepository.createProject(p)).map((_) => p);
  }
}
