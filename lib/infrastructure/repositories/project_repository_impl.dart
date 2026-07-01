import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:tracker/core/errors/failures.dart';
import 'package:tracker/domain/entities/project.dart';
import 'package:tracker/domain/repositories/project_repository.dart';
import 'package:tracker/infrastructure/persistence/app_database.dart';
import 'package:tracker/infrastructure/persistence/daos/project_dao.dart';

@LazySingleton(as: IProjectRepository)
class ProjectRepositoryImpl implements IProjectRepository {
  final ProjectDao _dao;
  ProjectRepositoryImpl(this._dao);

  @override
  Future<Either<Failure, Unit>> createProject(Project project) async {
    try {
      await _dao.insertProject(_toCompanion(project));
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('Failed to create project: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Project>>> getProjects() async {
    try {
      final rows = await _dao.getAllProjects();
      return Right(rows.map(_toDomain).toList());
    } catch (e) {
      return Left(DatabaseFailure('Failed to get projects: ${e.toString()}'));
    }
  }

  Project _toDomain(ProjectRow row) => Project(
    id: row.id,
    name: row.name,
    description: row.description,
    createdAt: row.createdAt,
  );

  ProjectsCompanion _toCompanion(Project project) => ProjectsCompanion(
    id: Value(project.id),
    name: Value(project.name),
    description: Value(project.description),
    createdAt: Value(project.createdAt),
  );
}
