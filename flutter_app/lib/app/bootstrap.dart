import "package:flutter/widgets.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:intl/date_symbol_data_local.dart";

import "glossip_app.dart";

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await initializeDateFormatting("pt_BR");
  runApp(const ProviderScope(child: GlossipApp()));
}
