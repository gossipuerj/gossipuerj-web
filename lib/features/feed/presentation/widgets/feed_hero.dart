import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../../../../core/theme/glossip_colors.dart";

class FeedHeroText extends StatelessWidget {
  const FeedHeroText({super.key, required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.urbanist(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontSize: isCompact ? 46 : 72,
      height: 1,
      letterSpacing: -3.1,
      shadows: const [
        Shadow(color: Colors.black38, offset: Offset(1.2, 0), blurRadius: 0),
        Shadow(color: Colors.black38, offset: Offset(2.4, 0), blurRadius: 0),
        Shadow(color: Colors.black26, offset: Offset(3.2, 0), blurRadius: 0),
      ],
    );

    return Column(
      crossAxisAlignment: isCompact
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        RichText(
          textAlign: isCompact ? TextAlign.center : TextAlign.left,
          text: TextSpan(
            style: titleStyle,
            children: [
              const TextSpan(text: "O QUE ESTÁ ROLANDO NA "),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [GlossipColors.primary, GlossipColors.secondary],
                  ).createShader(bounds),
                  child: Text(
                    "UERJ",
                    style: titleStyle.copyWith(
                      shadows: const [
                        Shadow(
                          color: Color.fromRGBO(255, 0, 255, 0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const TextSpan(text: "?"),
            ],
          ),
        ),
        const SizedBox(height: 24),
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
            child: const Text(
              "FOFOCAS ANÔNIMAS, SEGREDOS E CRUSHES DO CAMPUS.",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: -0.4,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0.8, 0),
                    blurRadius: 0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
