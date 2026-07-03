import 'package:flutter/material.dart';
import 'package:tracker/domain/entities/project.dart';

class ProjectListTile extends StatelessWidget {
  const ProjectListTile({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(project.name),
      subtitle: Text(project.description ?? ''),
    );
  }
}
