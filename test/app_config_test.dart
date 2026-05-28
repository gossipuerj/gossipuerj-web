import "package:flutter_test/flutter_test.dart";

import "package:flutter_app/app/config/app_config.dart";

void main() {
  group("AppConfig.resolveApiBaseUrl", () {
    test("uses localhost for local flavor", () {
      expect(
        AppConfig.resolveApiBaseUrl(flavor: RuntimeFlavor.local),
        "http://localhost:8080",
      );
    });

    test("uses production domain for prod flavor", () {
      expect(
        AppConfig.resolveApiBaseUrl(flavor: RuntimeFlavor.prod),
        "https://www.gossipuerj.com.br",
      );
    });

    test("honors explicit override", () {
      expect(
        AppConfig.resolveApiBaseUrl(
          flavor: RuntimeFlavor.prod,
          overrideBaseUrl: "https://example.com/custom",
        ),
        "https://example.com/custom",
      );
    });
  });
}
