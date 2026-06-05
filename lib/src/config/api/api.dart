import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:algo_rise/src/config/api/data_logger.dart';
import 'package:algo_rise/src/config/api/interceptors.dart';
import 'package:algo_rise/src/core/utils/path_provider.dart';

import '../app_config.dart';

CacheOptions cacheOptions = CacheOptions(
  store: HiveCacheStore(AppPathProvider.path),
  policy: CachePolicy.noCache,
  hitCacheOnErrorExcept: [],
  maxStale: const Duration(days: Config.cacheDays),
  //increase number of days for logger cache
  priority: CachePriority.high,
);
late final Dio dio;

class InitDio {
  call() {
    dio =
        Dio(
            BaseOptions(
              contentType: "application/json",
              baseUrl: Config.apiUrl,
            ),
          )
          ..interceptors.addAll([
            DioAuthInterceptors(),
            DataLogger(),
            DioCacheInterceptor(options: cacheOptions),
          ]);
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
  }
}
