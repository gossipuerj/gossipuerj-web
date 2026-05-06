import "dart:async";

import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "di/service_locator.dart";
import "../features/auth/presentation/session/session_cubit.dart";
import "../features/auth/presentation/session/session_state.dart";
import "../features/pages.dart";
import "../features/feed/presentation/widgets/feed_composer.dart";
import "../shared/layout/shell_frame.dart";

NoTransitionPage<void> _noTransitionPage({
  required LocalKey key,
  required Widget child,
}) => NoTransitionPage<void>(key: key, child: child);

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
      final isVerifyRoute = location == "/verificar";
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
                floatingActionButton: state.uri.path == "/"
                    ? const FeedComposerFab()
                    : null,
                child: child,
              );
            },
          );
        },
        routes: [
          GoRoute(
            path: "/",
            pageBuilder: (context, state) => _noTransitionPage(
              key: state.pageKey,
              child: const FeedPage(),
            ),
          ),
          GoRoute(
            path: "/login",
            pageBuilder: (context, state) => _noTransitionPage(
              key: state.pageKey,
              child: const LoginPage(),
            ),
          ),
          GoRoute(
            path: "/verificar",
            pageBuilder: (context, state) => _noTransitionPage(
              key: state.pageKey,
              child: VerifyPage(token: state.uri.queryParameters["token"]),
            ),
          ),
          GoRoute(
            path: "/crushes",
            pageBuilder: (context, state) => _noTransitionPage(
              key: state.pageKey,
              child: const CrushesPage(),
            ),
          ),
          GoRoute(
            path: "/eventos",
            pageBuilder: (context, state) => _noTransitionPage(
              key: state.pageKey,
              child: const EventsPage(),
            ),
          ),
          GoRoute(
            path: "/messages",
            pageBuilder: (context, state) => _noTransitionPage(
              key: state.pageKey,
              child: MessagesPage(
                initialUsername: state.uri.queryParameters["user"],
              ),
            ),
          ),
          GoRoute(
            path: "/profile",
            pageBuilder: (context, state) => _noTransitionPage(
              key: state.pageKey,
              child: const ProfilePage(),
            ),
          ),
        ],
      ),
    ],
  );
}
