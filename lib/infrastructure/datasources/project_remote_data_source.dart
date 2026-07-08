import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tracker/infrastructure/dtos/project_dto.dart';

abstract class IProjectRemoteDataSource {
  Future<List<ProjectDto>> getProjects();
}

@LazySingleton(as: IProjectRemoteDataSource)
class ProjectRemoteDataSource implements IProjectRemoteDataSource {
  final Dio _dio;
  ProjectRemoteDataSource(this._dio);

  @override
  Future<List<ProjectDto>> getProjects() async {
    final response = await _dio.get('/projects');
    return (response.data as List)
        .map((e) => ProjectDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
