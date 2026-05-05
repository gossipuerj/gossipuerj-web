import "package:dio/dio.dart";
import "package:get_it/get_it.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../core/error/error_mapper.dart";
import "../../core/network/dio_factory.dart";
import "../../core/storage/shared_preferences_token_store.dart";
import "../../core/storage/token_store.dart";
import "../../domain/repositories/auth_repository.dart";
import "../../features/auth/data/datasources/auth_remote_data_source.dart";
import "../../features/auth/data/repositories/auth_repository_impl.dart";
import "../../features/auth/presentation/auth/auth_cubit.dart";
import "../../features/auth/presentation/session/session_cubit.dart";
import "../../features/profile/presentation/profile_cubit.dart";
import "../../shared/state/mock_app_cubits.dart";
import "../config/app_config.dart";

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<AppConfig>(AppConfig.fromEnvironment());

  final preferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(preferences);
  getIt.registerSingleton<TokenStore>(
    SharedPreferencesTokenStore(getIt<SharedPreferences>()),
  );
  getIt.registerSingleton(const ErrorMapper());
  getIt.registerSingleton<Dio>(
    const DioFactory().create(getIt<AppConfig>(), getIt<TokenStore>()),
  );
  getIt.registerSingleton(AuthRemoteDataSource(getIt<Dio>()));
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<TokenStore>(),
      getIt<ErrorMapper>(),
    ),
  );
  getIt.registerSingleton(
    SessionCubit(getIt<AuthRepository>(), getIt<TokenStore>()),
  );
  getIt.registerFactory(
    () => AuthCubit(getIt<AuthRepository>(), getIt<SessionCubit>()),
  );
  getIt.registerFactory(() => ProfileCubit(getIt<AuthRepository>(), getIt<SessionCubit>()));
  getIt.registerSingleton(FeedCubit(getIt<SessionCubit>()));
  getIt.registerSingleton(ProfilesCubit());
  getIt.registerSingleton(MessagesCubit());
  getIt.registerSingleton(EventsCubit());
}
