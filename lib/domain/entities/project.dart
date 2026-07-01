import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'project.freezed.dart';

const _uuid = Uuid();

@freezed
abstract class Project with _$Project {
  const Project._();

  const factory Project({
    required String id,
    required name,
    String? description,
    required DateTime createdAt,
  }) = _Project;

  factory Project.create({required String name, String? description}) =>
      Project(
        id: _uuid.v4(),
        name: name,
        description: description,
        createdAt: DateTime.now().toUtc(),
      );
}
