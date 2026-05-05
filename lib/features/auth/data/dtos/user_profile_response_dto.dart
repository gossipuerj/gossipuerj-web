import "../../../../core/utils/enum_mappers.dart";
import "../../../../domain/models/user_profile.dart";

class UserProfileResponseDto {
  const UserProfileResponseDto({required this.json});

  factory UserProfileResponseDto.fromJson(Map<String, dynamic> json) {
    return UserProfileResponseDto(json: json);
  }

  final Map<String, dynamic> json;

  UserProfile toDomain() {
    return UserProfile(
      id: json["id"].toString(),
      username: (json["username"] ?? "") as String,
      email: json["email"]?.toString(),
      personalEmail: json["personalEmail"]?.toString(),
      firstName: json["firstName"]?.toString(),
      lastName: json["lastName"]?.toString(),
      avatarUrl: json["avatarUrl"]?.toString(),
      gender: EnumMappers.genderLabel(json["gender"]?.toString()),
      orientation: EnumMappers.orientationLabel(
        json["sexualOrientation"]?.toString(),
      ),
      course: json["course"]?.toString(),
      bio: json["bio"]?.toString(),
      showInGallery: (json["showInGallery"] as bool?) ?? true,
    );
  }
}
