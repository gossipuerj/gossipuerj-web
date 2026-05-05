import "package:flutter_test/flutter_test.dart";

import "package:flutter_app/shared/state/mock_app_cubits.dart";

void main() {
  test("normalizes filter values used by crushes", () {
    final cubit = ProfilesCubit();

    expect(cubit.normalizedOrientation("Gay"), "Homossexual");
    expect(cubit.normalizedOrientation("Lésbica"), "Homossexual");
    expect(cubit.normalizedGender("Não-binário"), "Não-Binário");
  });
}
