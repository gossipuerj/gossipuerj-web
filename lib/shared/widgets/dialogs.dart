import "package:flutter/material.dart";

import "../../core/theme/glossip_colors.dart";
import "art_pop_card.dart";
import "buttons.dart";

class GlossipDialog extends StatelessWidget {
  const GlossipDialog({
    super.key,
    required this.child,
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 24,
    ),
    this.padding = const EdgeInsets.all(28),
    this.color = const Color(0xFFFFF7FB),
    this.shadowOffset = const Offset(14, 14),
  });

  final Widget child;
  final EdgeInsets insetPadding;
  final EdgeInsets padding;
  final Color color;
  final Offset shadowOffset;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: insetPadding,
      child: GlossipCard(
        color: color,
        shadowOffset: shadowOffset,
        padding: padding,
        child: child,
      ),
    );
  }
}

class GlossipDialogHeader extends StatelessWidget {
  const GlossipDialogHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.trailing,
  });

  final String title;
  final String? eyebrow;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: glossipBoxDecoration(
              color: GlossipColors.accent,
              borderWidth: 3,
              shadowOffset: const Offset(6, 6),
            ),
            child: Text(
              eyebrow!.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 16), trailing!],
          ],
        ),
      ],
    );
  }
}

class GlossipConfirmationDialog extends StatelessWidget {
  const GlossipConfirmationDialog({
    super.key,
    required this.title,
    required this.confirmLabel,
    this.message,
    this.cancelLabel = "Cancelar",
    this.confirmBackground = GlossipColors.primary,
  });

  final String title;
  final String confirmLabel;
  final String? message;
  final String cancelLabel;
  final Color confirmBackground;

  @override
  Widget build(BuildContext context) {
    return GlossipDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const GlossipDialogHeader(
            title: "CONFIRMAR ACAO",
            eyebrow: "ATENCAO",
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 10),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withValues(alpha: 0.7),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: GlossipButton(
                  label: cancelLabel,
                  background: Colors.white,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlossipButton(
                  label: confirmLabel,
                  background: confirmBackground,
                  foreground: Colors.white,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
