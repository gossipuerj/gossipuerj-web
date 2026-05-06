import "package:flutter/material.dart";

import "../../core/theme/glossip_colors.dart";
import "art_pop_card.dart";

class GlossipButton extends StatelessWidget {
  const GlossipButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.background = GlossipColors.secondary,
    this.foreground = Colors.black,
    this.expanded = false,
    this.emphasizedLabel = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  });

  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final bool expanded;
  final bool emphasizedLabel;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: expanded ? double.infinity : null,
          padding: padding,
          decoration: BoxDecoration(
            color: onPressed == null
                ? background.withValues(alpha: 0.5)
                : background,
            border: Border.all(color: Colors.black, width: 3),
            boxShadow: onPressed == null
                ? null
                : const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
          ),
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w900,
              letterSpacing: emphasizedLabel ? -0.4 : null,
              shadows: emphasizedLabel
                  ? const [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0.8, 0),
                        blurRadius: 0,
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class GlossipIconButton extends StatelessWidget {
  const GlossipIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.background = Colors.white,
    this.foreground = Colors.black,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: onTap == null ? background.withValues(alpha: 0.5) : background,
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: onTap == null
              ? null
              : const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
        ),
        child: Icon(icon, color: foreground),
      ),
    );
  }
}

class SquareIconButton extends GlossipIconButton {
  const SquareIconButton({
    super.key,
    required super.icon,
    super.onTap,
    super.background = Colors.white,
    super.foreground = Colors.black,
  });
}

class GlossipIconTileButton extends StatelessWidget {
  const GlossipIconTileButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.background = Colors.white,
    this.foreground = Colors.black,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: glossipBoxDecoration(
          color: background,
          shadowOffset: const Offset(3, 3),
          borderWidth: 3,
        ),
        child: Icon(icon, color: foreground),
      ),
    );
  }
}

class SquareActionButton extends GlossipIconTileButton {
  const SquareActionButton({
    super.key,
    required super.icon,
    required super.onTap,
    super.background = Colors.white,
    super.foreground = Colors.black,
  });
}

class GlossipChipButton extends StatefulWidget {
  const GlossipChipButton({
    super.key,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  State<GlossipChipButton> createState() => _GlossipChipButtonState();
}

class ActionChipButton extends GlossipChipButton {
  const ActionChipButton({
    super.key,
    required super.label,
    super.active = false,
    super.onTap,
  });
}

class _GlossipChipButtonState extends State<GlossipChipButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = widget.active ? Colors.black : Colors.white;
    final foregroundTextColor = widget.active ? Colors.white : Colors.black;

    return MouseRegion(
      cursor: widget.onTap == null
          ? MouseCursor.defer
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 3, bottom: 3),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 3,
                top: 3,
                right: -3,
                bottom: -3,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: hovered ? GlossipColors.accent : Colors.black,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(
                  hovered ? -3 : 0,
                  hovered ? -3 : 0,
                  0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: foregroundColor,
                  border: Border.all(color: Colors.black, width: 3),
                ),
                child: Text(
                  widget.label.toUpperCase(),
                  style: TextStyle(
                    color: foregroundTextColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlossipMiniChipButton extends StatelessWidget {
  const GlossipMiniChipButton({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Text(label),
      ),
    );
  }
}

class IconChipButton extends GlossipMiniChipButton {
  const IconChipButton({super.key, required super.label, super.onTap});
}
