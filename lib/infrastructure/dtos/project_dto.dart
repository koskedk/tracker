import 'package:json_annotation/json_annotation.dart';
import 'package:tracker/domain/entities/project.dart';

part 'project_dto.g.dart';

@JsonSerializable()
class ProjectDto {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;

  ProjectDto({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  factory ProjectDto.fromJson(Map<String, dynamic> json) =>
      _$ProjectDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectDtoToJson(this);

  Project toDomain() => Project(
    id: id,
    name: name,
    description: description,
    createdAt: createdAt,
  );
}
