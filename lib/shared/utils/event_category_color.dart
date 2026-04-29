import "package:flutter/material.dart";

import "../../core/theme/glossip_colors.dart";

Color eventCategoryColor(String category) {
  switch (category) {
    case "Social":
      return const Color(0xFFFF4D4D);
    case "Acadêmico":
      return GlossipColors.secondary;
    case "Esporte":
      return const Color(0xFF4D94FF);
    case "Cultura":
      return const Color(0xFFB366FF);
    default:
      return Colors.black;
  }
}
