import "package:flutter/material.dart";

import "../../../../core/theme/glossip_colors.dart";
import "../../../../shared/widgets/glossip_components.dart";

class FeedFilterBar extends StatelessWidget {
  const FeedFilterBar({
    super.key,
    required this.width,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final double width;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: width < 600 ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: width < 600
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 4),
          ),
          child: const Text(
            "FEED RECENTE",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              letterSpacing: -0.6,
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
        const SizedBox(height: 16, width: 16),
        if (width < 600)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: _buttons),
          )
        else
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _buttons,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> get _buttons => [
    for (final category in categories)
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: GlossipButton(
          label: category,
          background: selectedCategory == category
              ? GlossipColors.primary
              : Colors.white,
          foreground: selectedCategory == category
              ? Colors.white
              : Colors.black,
          onPressed: () => onCategorySelected(category),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        ),
      ),
  ];
}
