import "package:flutter/material.dart";

import "../../core/theme/glossip_colors.dart";

class GretchenBlob extends StatelessWidget {
  const GretchenBlob({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 350,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Transform.rotate(
              angle: 0.17,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [GlossipColors.secondary, GlossipColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(120),
                  boxShadow: [
                    BoxShadow(
                      color: GlossipColors.secondary.withValues(alpha: 0.35),
                      blurRadius: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Transform.rotate(
              angle: 0.08,
              child: Image.asset(
                "assets/images/gretchen.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: -10,
            child: Transform.rotate(
              angle: 0.25,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.white, width: 3),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black, offset: Offset(8, 8)),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: const Text(
                  "FURO EXCLUSIVO",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
