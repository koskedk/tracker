import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:tracker/core/config/app_config.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio() {
    developer.log('Using API base URL: ${AppConfig.baseUrl}', name: 'NetworkModule');

    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: false,
          logPrint: (obj) => developer.log(obj.toString(), name: 'Dio'),
        ),
      );
    }

    return dio;
  }
}
