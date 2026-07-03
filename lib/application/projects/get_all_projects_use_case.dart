import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:tracker/core/errors/failures.dart';
import 'package:tracker/core/usecases/use_case.dart';
import 'package:tracker/domain/entities/project.dart';
import 'package:tracker/domain/repositories/project_repository.dart';

@Injectable()
class GetAllProjectsUseCase implements UseCase<List<Project>, NoParams> {
  final IProjectRepository projectRepository;
  const GetAllProjectsUseCase(this.projectRepository);

  @override
  Future<Either<Failure, List<Project>>> call(NoParams params) async {
    return (await projectRepository.getProjects());
  }
}
