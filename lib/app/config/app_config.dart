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
        isDebug: kDebugMode,
        overrideBaseUrl: const String.fromEnvironment(
          "API_BASE_URL",
          defaultValue: "",
        ),
      ),
      isDebug: kDebugMode,
    );
  }

  static String resolveApiBaseUrl({
    required bool isDebug,
    String overrideBaseUrl = "",
  }) {
    if (overrideBaseUrl.isNotEmpty) {
      return overrideBaseUrl;
    }

    return isDebug ? "http://localhost:8080/" : "http://localhost:8080/api";
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
