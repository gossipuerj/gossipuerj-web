import "package:flutter/widgets.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/date_symbol_data_local.dart";

import "platform/platform_setup.dart";
import "glossip_app.dart";

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  configurePlatformSetup();
  await initializeDateFormatting("pt_BR");
  runApp(const ProviderScope(child: GlossipApp()));
}
