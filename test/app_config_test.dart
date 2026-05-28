import "package:flutter_test/flutter_test.dart";

import "package:flutter_app/app/config/app_config.dart";

void main() {
  group("AppConfig.resolveApiBaseUrl", () {
    test("uses localhost root in debug", () {
      expect(
        AppConfig.resolveApiBaseUrl(isDebug: true),
        "http://localhost:8080/",
      );
    });

    test("uses localhost api prefix in release", () {
      expect(
        AppConfig.resolveApiBaseUrl(isDebug: false),
        "http://localhost:8080/api",
      );
    });

    test("honors explicit override", () {
      expect(
        AppConfig.resolveApiBaseUrl(
          isDebug: false,
          overrideBaseUrl: "https://example.com/custom",
        ),
        "https://example.com/custom",
      );
    });
  });
}
