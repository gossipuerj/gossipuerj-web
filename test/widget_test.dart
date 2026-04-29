import "package:flutter_test/flutter_test.dart";

import "package:flutter_app/core/app_controller.dart";

void main() {
  test("normalizes filter values used by crushes", () {
    final controller = AppController();

    expect(controller.normalizedOrientation("Gay"), "Homossexual");
    expect(controller.normalizedOrientation("Lésbica"), "Homossexual");
    expect(controller.normalizedGender("Não-binário"), "Não-Binário");
  });
}
