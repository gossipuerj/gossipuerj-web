import "package:flutter/material.dart";

import "../../core/theme/glossip_colors.dart";

class HashtagText extends StatelessWidget {
  const HashtagText(this.content, {super.key, this.style});

  final String content;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final regex = RegExp(r"(#[a-zA-Z0-9_]+)");
    final spans = <InlineSpan>[];
    final matches = regex.allMatches(content).toList();
    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: content.substring(start, match.start)));
      }
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              border: Border.all(color: Colors.black),
            ),
            child: Text(
              match.group(0)!,
              style: const TextStyle(
                color: GlossipColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      );
      start = match.end;
    }

    if (start < content.length) {
      spans.add(TextSpan(text: content.substring(start)));
    }

    return RichText(
      text: TextSpan(style: style, children: spans),
    );
  }
}
