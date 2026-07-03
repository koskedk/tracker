import 'package:flutter/material.dart';
import 'package:tracker/application/projects/get_all_projects_use_case.dart';
import 'package:tracker/core/di/injection.dart';
import 'package:tracker/core/usecases/use_case.dart';
import 'package:tracker/domain/entities/project.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final GetAllProjectsUseCase _getProjects = getIt<GetAllProjectsUseCase>();

  bool _loading = true;
  String? _error;
  List<Project> _projects = const [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _getProjects(NoParams());

    if (!mounted) return;

    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failure.toString();
      }),
      (projects) => setState(() {
        _loading = false;
        _projects = projects;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projects')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    return ListView.builder(
      itemCount: _projects.length,
      itemBuilder: (context, index) {
        final project = _projects[index];
        return ListTile(
          title: Text(project.name),
          subtitle: Text(project.description ?? ''),
        );
      },
    );
  }
}
