import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../shared/layout/shell_frame.dart";
import "../shared/providers/app_providers.dart";
import "../features/pages.dart";

final GoRouter appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Consumer(
          builder: (context, ref, _) {
            final controller = ref.watch(sessionControllerProvider);
            return ShellFrame(
              currentPath: state.uri.path,
              isLoggedIn: controller.isLoggedIn,
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
          path: "/crushes",
          builder: (context, state) => const CrushesPage(),
        ),
        GoRoute(
          path: "/eventos",
          builder: (context, state) => const EventsPage(),
        ),
        GoRoute(
          path: "/messages",
          builder: (context, state) {
            return MessagesPage(
              initialUsername: state.uri.queryParameters["user"],
            );
          },
        ),
        GoRoute(
          path: "/profile",
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
  ],
);
