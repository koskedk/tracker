// Run explicitly (skipped by default via dart_test.yaml):
//   flutter test --tags=integration --run-skipped --dart-define-from-file=env/test.json
@Tags(['integration'])
library;

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracker/core/config/app_config.dart';
import 'package:tracker/infrastructure/datasources/project_remote_data_source.dart';

void main() {
  test('fetches real projects from the configured backend', () async {
    // ignore: avoid_print
    print('Hitting BASE_URL: ${AppConfig.baseUrl}');

    final dio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl));
    final dataSource = ProjectRemoteDataSource(dio);

    final projects = await dataSource.getProjects();

    expect(projects, isA<List>());
  });
}
