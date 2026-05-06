import "dart:math" as math;

import "package:flutter/material.dart";

import "../../core/theme/glossip_colors.dart";

BoxDecoration glossipBoxDecoration({
  Color color = Colors.white,
  Color shadowColor = Colors.black,
  double borderWidth = 4,
  Offset shadowOffset = const Offset(8, 8),
}) {
  return BoxDecoration(
    color: color,
    border: Border.all(color: Colors.black, width: borderWidth),
    boxShadow: [BoxShadow(color: shadowColor, offset: shadowOffset)],
  );
}

BoxDecoration borderedBoxDecoration({
  Color color = Colors.white,
  Color shadowColor = Colors.black,
  double borderWidth = 4,
  Offset shadowOffset = const Offset(8, 8),
}) {
  return glossipBoxDecoration(
    color: color,
    shadowColor: shadowColor,
    borderWidth: borderWidth,
    shadowOffset: shadowOffset,
  );
}

class GlossipCard extends StatelessWidget {
  const GlossipCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.color = Colors.white,
    this.shadowColor = Colors.black,
    this.shadowOffset = const Offset(12, 12),
    this.margin,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final Color shadowColor;
  final Offset shadowOffset;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: glossipBoxDecoration(
        color: color,
        shadowColor: shadowColor,
        shadowOffset: shadowOffset,
      ),
      child: child,
    );
  }
}

class ArtPopCard extends GlossipCard {
  const ArtPopCard({
    super.key,
    required super.child,
    super.padding = const EdgeInsets.all(24),
    super.color = Colors.white,
    super.shadowColor = Colors.black,
    super.shadowOffset = const Offset(12, 12),
    super.margin,
  });
}

class GlossipHoverCard extends StatefulWidget {
  const GlossipHoverCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.color = Colors.white,
    this.shadowColor = Colors.black,
    this.hoverShadowColor = GlossipColors.secondary,
    this.shadowOffset = const Offset(12, 12),
    this.hoverForegroundOffset = const Offset(-4, -4),
    this.margin,
    this.duration = const Duration(milliseconds: 160),
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final Color shadowColor;
  final Color hoverShadowColor;
  final Offset shadowOffset;
  final Offset hoverForegroundOffset;
  final EdgeInsets? margin;
  final Duration duration;

  @override
  State<GlossipHoverCard> createState() => _GlossipHoverCardState();
}

class HoverArtPopCard extends GlossipHoverCard {
  const HoverArtPopCard({
    super.key,
    required super.child,
    super.padding = const EdgeInsets.all(24),
    super.color = Colors.white,
    super.shadowColor = Colors.black,
    super.hoverShadowColor = GlossipColors.secondary,
    super.shadowOffset = const Offset(12, 12),
    super.hoverForegroundOffset = const Offset(-4, -4),
    super.margin,
    super.duration = const Duration(milliseconds: 160),
  });
}

class _GlossipHoverCardState extends State<GlossipHoverCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = hovered
        ? widget.hoverShadowColor
        : widget.shadowColor;
    final foregroundOffset = hovered
        ? widget.hoverForegroundOffset
        : Offset.zero;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: Container(
        margin: widget.margin,
        padding: EdgeInsets.only(
          right: math.max(widget.shadowOffset.dx, 0),
          bottom: math.max(widget.shadowOffset.dy, 0),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: widget.shadowOffset.dx,
              top: widget.shadowOffset.dy,
              right: -widget.shadowOffset.dx,
              bottom: -widget.shadowOffset.dy,
              child: AnimatedContainer(
                duration: widget.duration,
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: Colors.black, width: 4),
                ),
              ),
            ),
            AnimatedContainer(
              duration: widget.duration,
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(
                foregroundOffset.dx,
                foregroundOffset.dy,
                0,
              ),
              decoration: BoxDecoration(
                color: widget.color,
                border: Border.all(color: Colors.black, width: 4),
              ),
              child: Padding(padding: widget.padding, child: widget.child),
            ),
          ],
        ),
      ),
    );
  }
}
