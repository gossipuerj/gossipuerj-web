import "package:flutter/material.dart";

import "../../core/theme/glossip_colors.dart";

class GlossipSectionLabel extends StatelessWidget {
  const GlossipSectionLabel(this.text, {super.key, this.rotation = -0.02});

  final String text;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: GlossipColors.accent,
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(6, 6)),
          ],
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class SectionLabel extends GlossipSectionLabel {
  const SectionLabel(super.text, {super.key, super.rotation = -0.02});
}

class GlossipHeroTitle extends StatelessWidget {
  const GlossipHeroTitle({
    super.key,
    required this.titleStart,
    required this.titleHighlight,
    required this.subtitle,
    this.gradient2 = false,
  });

  final String titleStart;
  final String titleHighlight;
  final String subtitle;
  final bool gradient2;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: width < 600 ? 42 : 62,
              shadows: const [
                Shadow(color: Colors.black, offset: Offset(4, 4)),
              ],
            ),
            children: [
              TextSpan(text: titleStart),
              TextSpan(
                text: titleHighlight,
                style: TextStyle(
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: gradient2
                          ? const [
                              GlossipColors.secondary,
                              GlossipColors.accent,
                            ]
                          : const [
                              GlossipColors.primary,
                              GlossipColors.secondary,
                            ],
                    ).createShader(Rect.fromLTWH(0, 0, 240, 60)),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Transform.rotate(
          angle: 0.02,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: GlossipColors.accent,
              border: Border.all(color: Colors.black, width: 4),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(6, 6)),
              ],
            ),
            child: Text(
              subtitle.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HeroTitle extends GlossipHeroTitle {
  const HeroTitle({
    super.key,
    required super.titleStart,
    required super.titleHighlight,
    required super.subtitle,
    super.gradient2 = false,
  });
}

class GlossipPageHeader extends StatelessWidget {
  const GlossipPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 48,
            shadows: [Shadow(color: Colors.black, offset: Offset(4, 4))],
          ),
        ),
        const SizedBox(height: 8),
        Transform.rotate(
          angle: -0.02,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: GlossipColors.accent,
              border: Border.all(color: Colors.black, width: 4),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(6, 6)),
              ],
            ),
            child: Text(
              subtitle.toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PageHeader extends GlossipPageHeader {
  const PageHeader({super.key, required super.title, required super.subtitle});
}

class GlossipTag extends StatelessWidget {
  const GlossipTag({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 11,
        ),
      ),
    );
  }
}

class TagLabel extends GlossipTag {
  const TagLabel({super.key, required super.text});
}

class MetaText extends StatelessWidget {
  const MetaText({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.black),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
