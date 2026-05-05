import "dart:typed_data";

class UserProfile {
  const UserProfile({
    required this.id,
    required this.username,
    this.email,
    this.personalEmail,
    this.firstName,
    this.lastName,
    this.instagram,
    this.avatarUrl,
    this.avatarBytes,
    this.gender,
    this.orientation,
    this.course,
    this.bio,
    this.showInGallery = true,
  });

  final String id;
  final String username;
  final String? email;
  final String? personalEmail;
  final String? firstName;
  final String? lastName;
  final String? instagram;
  final String? avatarUrl;
  final Uint8List? avatarBytes;
  final String? gender;
  final String? orientation;
  final String? course;
  final String? bio;
  final bool showInGallery;

  String get displayName {
    final composed = "${firstName ?? ""} ${lastName ?? ""}".trim();
    return composed.isEmpty ? "@$username" : composed;
  }

  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    String? personalEmail,
    String? firstName,
    String? lastName,
    String? instagram,
    String? avatarUrl,
    Uint8List? avatarBytes,
    String? gender,
    String? orientation,
    String? course,
    String? bio,
    bool? showInGallery,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      personalEmail: personalEmail ?? this.personalEmail,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      instagram: instagram ?? this.instagram,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarBytes: avatarBytes ?? this.avatarBytes,
      gender: gender ?? this.gender,
      orientation: orientation ?? this.orientation,
      course: course ?? this.course,
      bio: bio ?? this.bio,
      showInGallery: showInGallery ?? this.showInGallery,
    );
  }
}
