import "package:flutter/foundation.dart";

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.isDebug,
  });

  factory AppConfig.fromEnvironment() {
    const flavorName = String.fromEnvironment(
      "APP_FLAVOR",
      defaultValue: "local",
    );
    final flavor = RuntimeFlavor.fromName(flavorName);

    return AppConfig(
      flavor: flavor,
      apiBaseUrl: resolveApiBaseUrl(
        flavor: flavor,
        overrideBaseUrl: const String.fromEnvironment(
          "API_BASE_URL",
          defaultValue: "",
        ),
      ),
      isDebug: kDebugMode,
    );
  }

  static String resolveApiBaseUrl({
    required RuntimeFlavor flavor,
    String overrideBaseUrl = "",
  }) {
    if (overrideBaseUrl.isNotEmpty) {
      return overrideBaseUrl;
    }

    if (flavor == RuntimeFlavor.prod) {
      return "https://www.gossipuerj.com.br";
    }

    return "http://localhost:8080";
  }

  final RuntimeFlavor flavor;
  final String apiBaseUrl;
  final bool isDebug;
}

enum RuntimeFlavor {
  local("local"),
  staging("staging"),
  prod("prod");

  const RuntimeFlavor(this.name);

  final String name;

  static RuntimeFlavor fromName(String value) {
    for (final flavor in RuntimeFlavor.values) {
      if (flavor.name == value) {
        return flavor;
      }
    }
    return RuntimeFlavor.local;
  }
}
