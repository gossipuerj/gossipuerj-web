class LoginResponseDto {
  const LoginResponseDto({required this.token});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(token: json["token"] as String);
  }

  final String token;
}
