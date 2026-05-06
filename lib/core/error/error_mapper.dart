import "package:dio/dio.dart";

import "app_exception.dart";

class ErrorMapper {
  const ErrorMapper();

  AppException map(Object error) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return const AppException("A requisição expirou. Tente novamente.");
      }

      if (error.type == DioExceptionType.connectionError) {
        return const AppException(
          "Não foi possível se conectar à API. Verifique se o backend está online.",
        );
      }

      final data = error.response?.data;
      final statusCode = error.response?.statusCode;

      if (data is Map<String, dynamic>) {
        final validationErrors = data["errors"];
        if (validationErrors is List) {
          final fieldErrors = <String, String>{};
          for (final item in validationErrors) {
            if (item is Map<String, dynamic>) {
              final field = item["field"]?.toString();
              final message = item["message"]?.toString();
              if (field != null && message != null) {
                fieldErrors[field] = message;
              }
            }
          }
          return ValidationException(
            message: data["message"]?.toString() ?? "Erro de validação",
            fieldErrors: fieldErrors,
            statusCode: statusCode,
          );
        }

        final message = data["message"]?.toString();
        if (message != null && message.isNotEmpty) {
          return AppException(message, statusCode: statusCode);
        }
      }

      if (statusCode == 401) {
        return const AppException(
          "Sua sessão expirou. Faça login novamente.",
          statusCode: 401,
        );
      }

      return AppException(
        error.message ?? "Ocorreu um erro inesperado.",
        statusCode: statusCode,
      );
    }

    return AppException(error.toString());
  }
}
