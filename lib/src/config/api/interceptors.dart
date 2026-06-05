import 'dart:io';

import 'package:dio/dio.dart';


class DioAuthInterceptors extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // get token from where it is store
     String  token = "";
      options.headers
          .addAll({HttpHeaders.authorizationHeader: "Bearer $token"});
          handler.next(options);
    } catch (_) {
      
    }
  }
}
