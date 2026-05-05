import "package:flutter/widgets.dart";
import "package:intl/date_symbol_data_local.dart";

import "di/service_locator.dart";
import "platform/platform_setup.dart";
import "glossip_app.dart";

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  configurePlatformSetup();
  await initializeDateFormatting("pt_BR");
  await setupDependencies();
  runApp(const GlossipApp());
}
