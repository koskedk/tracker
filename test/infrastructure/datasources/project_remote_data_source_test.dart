import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tracker/infrastructure/datasources/project_remote_data_source.dart';

class _MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

void main() {
  late Dio dio;
  late _MockHttpClientAdapter adapter;
  late ProjectRemoteDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    adapter = _MockHttpClientAdapter();
    dio = Dio(BaseOptions(baseUrl: 'http://test.local'))
      ..httpClientAdapter = adapter;
    dataSource = ProjectRemoteDataSource(dio);
  });

  ResponseBody jsonResponse(String body) => ResponseBody.fromString(
    body,
    200,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  test('maps a successful response to ProjectDto list', () async {
    when(
      () => adapter.fetch(any(), any(), any()),
    ).thenAnswer(
      (_) async => jsonResponse(
        '[{"id":"1","name":"County Hospital","description":"d","createdAt":"2026-01-01T00:00:00.000Z"}]',
      ),
    );

    final result = await dataSource.getProjects();

    expect(result, hasLength(1));
    expect(result.first.name, 'County Hospital');
    expect(result.first.toDomain().name, 'County Hospital');
  });

  test('propagates transport errors', () async {
    when(() => adapter.fetch(any(), any(), any())).thenThrow(
      DioException(requestOptions: RequestOptions(path: '/projects')),
    );

    expect(() => dataSource.getProjects(), throwsA(isA<DioException>()));
  });
}
