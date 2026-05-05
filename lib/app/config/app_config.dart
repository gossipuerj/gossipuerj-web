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
      apiBaseUrl: const String.fromEnvironment(
        "API_BASE_URL",
        defaultValue: "",
      ).ifEmpty(flavor.defaultBaseUrl),
      isDebug: kDebugMode,
    );
  }

  final RuntimeFlavor flavor;
  final String apiBaseUrl;
  final bool isDebug;
}

enum RuntimeFlavor {
  local("local", "http://localhost:8080/"),
  staging("staging", "http://localhost:8080/"),
  prod("prod", "http://163.176.222.215:8080/");

  const RuntimeFlavor(this.name, this.defaultBaseUrl);

  final String name;
  final String defaultBaseUrl;

  static RuntimeFlavor fromName(String value) {
    for (final flavor in RuntimeFlavor.values) {
      if (flavor.name == value) {
        return flavor;
      }
    }
    return RuntimeFlavor.local;
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
