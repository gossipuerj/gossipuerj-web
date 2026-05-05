import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "di/service_locator.dart";
import "../features/auth/presentation/session/session_cubit.dart";
import "../features/auth/presentation/session/session_state.dart";
import "../features/pages.dart";
import "../shared/layout/shell_frame.dart";

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: "/",
    refreshListenable: RouterRefreshNotifier(getIt<SessionCubit>().stream),
    redirect: (context, state) {
      final sessionState = getIt<SessionCubit>().state;
      final location = state.uri.path;
      final isLoggedIn = sessionState.status == SessionStatus.authenticated;
      final isLoginRoute = location == "/login";
      final isVerifyRoute = location == "/auth/verify";
      final isProfileRoute = location == "/profile";

      if (!isLoggedIn && isProfileRoute) {
        return "/login";
      }

      if (isLoggedIn && isLoginRoute) {
        return "/profile";
      }

      if (isLoggedIn && isVerifyRoute) {
        return "/profile";
      }

      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return BlocBuilder<SessionCubit, SessionState>(
            builder: (context, sessionState) {
              return ShellFrame(
                currentPath: state.uri.path,
                isLoggedIn: sessionState.isAuthenticated,
                onNavigate: (path) => context.go(path),
                child: child,
              );
            },
          );
        },
        routes: [
          GoRoute(path: "/", builder: (context, state) => const FeedPage()),
          GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
          GoRoute(
            path: "/auth/verify",
            builder: (context, state) => VerifyPage(token: state.uri.queryParameters["token"]),
          ),
          GoRoute(
            path: "/crushes",
            builder: (context, state) => const CrushesPage(),
          ),
          GoRoute(
            path: "/eventos",
            builder: (context, state) => const EventsPage(),
          ),
          GoRoute(
            path: "/messages",
            builder: (context, state) =>
                MessagesPage(initialUsername: state.uri.queryParameters["user"]),
          ),
          GoRoute(
            path: "/profile",
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
