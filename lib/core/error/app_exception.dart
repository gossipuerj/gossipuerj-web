class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ValidationException extends AppException {
  const ValidationException({
    required String message,
    required this.fieldErrors,
    int? statusCode,
  }) : super(message, statusCode: statusCode);

  final Map<String, String> fieldErrors;
}
