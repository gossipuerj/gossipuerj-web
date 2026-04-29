import "package:flutter_test/flutter_test.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:flutter_app/shared/providers/app_providers.dart";

void main() {
  test("normalizes filter values used by crushes", () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(profilesControllerProvider);

    expect(controller.normalizedOrientation("Gay"), "Homossexual");
    expect(controller.normalizedOrientation("Lésbica"), "Homossexual");
    expect(controller.normalizedGender("Não-binário"), "Não-Binário");
  });
}
