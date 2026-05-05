import "../../../../core/error/error_mapper.dart";
import "../../../../core/storage/token_store.dart";
import "../../../../core/utils/enum_mappers.dart";
import "../../../../domain/models/user_profile.dart";
import "../../../../domain/repositories/auth_repository.dart";
import "../datasources/auth_remote_data_source.dart";
import "../dtos/login_response_dto.dart";
import "../dtos/user_profile_response_dto.dart";

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._tokenStore, this._errorMapper);

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStore _tokenStore;
  final ErrorMapper _errorMapper;

  @override
  Future<UserProfile> getCurrentUser() async {
    try {
      final json = await _remoteDataSource.getMe();
      return UserProfileResponseDto.fromJson(json).toDomain();
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  @override
  Future<void> logout() async {
    await _tokenStore.clear();
  }

  @override
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    String? personalEmail,
  }) async {
    try {
      await _remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        personalEmail: personalEmail,
      );
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  @override
  Future<void> requestLoginMagicLink(String email) async {
    try {
      await _remoteDataSource.requestLoginMagicLink(email);
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  @override
  Future<UserProfile> updateCurrentUser({
    String? username,
    String? course,
    String? bio,
    String? avatarUrl,
    String? gender,
    String? orientation,
    bool? showInGallery,
  }) async {
    try {
      final json = await _remoteDataSource.updateMe(
        username: username,
        course: course,
        bio: bio,
        avatarUrl: avatarUrl,
        gender: EnumMappers.genderApi(gender),
        orientation: EnumMappers.orientationApi(orientation),
        showInGallery: showInGallery,
      );
      return UserProfileResponseDto.fromJson(json).toDomain();
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }

  @override
  Future<String> verifyMagicLink(String token) async {
    try {
      final json = await _remoteDataSource.verifyMagicLink(token);
      final response = LoginResponseDto.fromJson(json);
      await _tokenStore.write(response.token);
      return response.token;
    } catch (error) {
      throw _errorMapper.map(error);
    }
  }
}
