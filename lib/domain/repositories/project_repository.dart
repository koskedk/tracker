import 'package:fpdart/fpdart.dart';
import 'package:tracker/core/errors/failures.dart';
import 'package:tracker/domain/entities/project.dart';

abstract class IProjectRepository {
  Future<Either<Failure, List<Project>>> getProjects();
  Future<Either<Failure, Unit>> createProject(Project project);
}
