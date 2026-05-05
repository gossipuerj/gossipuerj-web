import "package:dio/dio.dart";

import "../../app/config/app_config.dart";
import "../storage/token_store.dart";
import "auth_interceptor.dart";

class DioFactory {
  const DioFactory();

  Dio create(AppConfig config, TokenStore tokenStore) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(AuthInterceptor(tokenStore));
    if (config.isDebug) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
    return dio;
  }
}
