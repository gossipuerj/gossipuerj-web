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

    if (_usesApiPrefix(config.apiBaseUrl)) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.path = _stripApiPrefix(options.path);
            handler.next(options);
          },
        ),
      );
    }

    dio.interceptors.add(AuthInterceptor(tokenStore));
    if (config.isDebug) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
    return dio;
  }
}

String _stripApiPrefix(String path) {
  if (!path.startsWith("/api")) {
    return path;
  }

  final normalizedPath = path.substring(4);
  return normalizedPath.isEmpty ? "/" : normalizedPath;
}

bool _usesApiPrefix(String baseUrl) {
  final uri = Uri.tryParse(baseUrl);
  if (uri == null) {
    return baseUrl.endsWith("/api") || baseUrl.endsWith("/api/");
  }

  final normalizedPath = uri.path.replaceFirst(RegExp(r"/+$"), "");
  return normalizedPath == "/api";
}
