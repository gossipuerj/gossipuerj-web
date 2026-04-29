import "package:flutter/foundation.dart";
import "package:flutter_web_plugins/url_strategy.dart";

void configurePlatformSetup() {
  if (kIsWeb) {
    usePathUrlStrategy();
  }
}
