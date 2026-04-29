import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";

import "../core/theme/glossip_theme.dart";
import "router.dart";

class GlossipApp extends StatelessWidget {
  const GlossipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "GlossipUerj",
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: appRouter,
      locale: const Locale("pt", "BR"),
      supportedLocales: const [Locale("pt", "BR")],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
