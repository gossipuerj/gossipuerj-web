import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:go_router/go_router.dart";

import "di/service_locator.dart";
import "../core/theme/glossip_theme.dart";
import "../features/auth/presentation/auth/auth_cubit.dart";
import "../features/auth/presentation/session/session_cubit.dart";
import "../features/profile/presentation/profile_cubit.dart";
import "../shared/state/mock_app_cubits.dart";
import "router.dart";

class GlossipApp extends StatefulWidget {
  const GlossipApp({super.key});

  @override
  State<GlossipApp> createState() => _GlossipAppState();
}

class _GlossipAppState extends State<GlossipApp> {
  late final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>(
          lazy: false,
          create: (_) => getIt<SessionCubit>()..start(),
        ),
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
        BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
        BlocProvider<FeedCubit>(create: (_) => getIt<FeedCubit>()),
        BlocProvider<ProfilesCubit>(create: (_) => getIt<ProfilesCubit>()),
        BlocProvider<MessagesCubit>(create: (_) => getIt<MessagesCubit>()),
        BlocProvider<EventsCubit>(create: (_) => getIt<EventsCubit>()),
      ],
      child: MaterialApp.router(
        title: "GlossipUerj",
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        routerConfig: _router,
        locale: const Locale("pt", "BR"),
        supportedLocales: const [Locale("pt", "BR")],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
