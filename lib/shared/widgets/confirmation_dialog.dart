import "package:flutter/material.dart";

import "dialogs.dart";

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.confirmLabel,
  });

  final String title;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    return GlossipConfirmationDialog(title: title, confirmLabel: confirmLabel);
  }
}
