import 'package:flutter_test/flutter_test.dart';
import 'package:tracker/domain/entities/project.dart';

void main() {
  Project p = Project.create(name: "test", description: "test project");
  test('project should have uuid', () {
    expect(p.id, isNotNull);
    print(p.id);
  });
}
