import "package:dio/dio.dart";

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<void> requestLoginMagicLink(String email) async {
    await _dio.post("/api/auth/login", data: {"email": email});
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    String? personalEmail,
  }) async {
    await _dio.post(
      "/api/auth/register",
      data: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "personalEmail": personalEmail,
      },
    );
  }

  Future<Map<String, dynamic>> verifyMagicLink(String token) async {
    final response = await _dio.post(
      "/api/auth/verify",
      data: {"token": token},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get("/api/auth/me");
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> updateMe({
    String? username,
    String? course,
    String? bio,
    String? avatarUrl,
    String? gender,
    String? orientation,
    bool? showInGallery,
  }) async {
    final response = await _dio.patch(
      "/api/v1/auth/me",
      data: {
        "username": username,
        "course": course,
        "bio": bio,
        "avatarUrl": avatarUrl,
        "gender": gender,
        "orientation": orientation,
        "showInGallery": showInGallery,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}
