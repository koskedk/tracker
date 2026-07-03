import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/application/projects/create_project_use_case.dart';
import 'package:tracker/application/projects/get_all_projects_use_case.dart';
import 'package:tracker/core/di/injection.dart';
import 'package:tracker/core/usecases/use_case.dart';
import 'package:tracker/domain/entities/project.dart';

final projectListProvider =
    AsyncNotifierProvider<ProjectListNotifer, List<Project>>(
      ProjectListNotifer.new,
    );

class ProjectListNotifer extends AsyncNotifier<List<Project>> {
  final GetAllProjectsUseCase _getProjects = getIt<GetAllProjectsUseCase>();
  final CreateProjectUseCase _createProject = getIt<CreateProjectUseCase>();

  @override
  Future<List<Project>> build() async {
    final result = await _getProjects(NoParams());
    return result.fold((failure) => throw failure, (projects) => projects);
  }

  Future<String?> createProject({
    required String name,
    String? description,
  }) async {
    final result = await _createProject(
      CreateProjectParams(name: name, description: description),
    );
    return result.fold((failure) => failure.toString(), (_) {
      ref.invalidateSelf();
      return null;
    });
  }
}
