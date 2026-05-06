import "package:flutter/material.dart";

class GlossipFieldLabel extends StatelessWidget {
  const GlossipFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w900,
        fontSize: 14,
      ),
    );
  }
}

class FieldLabel extends GlossipFieldLabel {
  const FieldLabel(super.text, {super.key});
}

class GlossipInput extends StatelessWidget {
  const GlossipInput({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    this.background = Colors.white,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: child,
    );
  }
}

class GlossipSelectField extends StatelessWidget {
  const GlossipSelectField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final normalizedItems = <String>{
      if (!items.contains(value)) value,
      ...items,
    }.toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
          items: [
            for (final item in normalizedItems)
              DropdownMenuItem<String>(value: item, child: Text(item)),
          ],
          onChanged: (next) {
            if (next != null) {
              onChanged(next);
            }
          },
        ),
      ),
    );
  }
}

class DropdownField extends GlossipSelectField {
  const DropdownField({
    super.key,
    required super.value,
    required super.items,
    required super.onChanged,
  });
}

class GlossipLabeledSelectField extends StatelessWidget {
  const GlossipLabeledSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        GlossipFieldLabel(label),
        const SizedBox(height: 8),
        GlossipSelectField(value: value, items: items, onChanged: onChanged),
      ],
    );
  }
}

class DropdownGroup extends GlossipLabeledSelectField {
  const DropdownGroup({
    super.key,
    required super.label,
    required super.value,
    required super.items,
    required super.onChanged,
  });
}

class GlossipLabeledTextField extends StatelessWidget {
  const GlossipLabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlossipFieldLabel(label),
        const SizedBox(height: 8),
        GlossipInput(
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration.collapsed(hintText: ""),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class LabeledTextField extends GlossipLabeledTextField {
  const LabeledTextField({
    super.key,
    required super.label,
    required super.controller,
    super.maxLines = 1,
  });
}

class GlossipGlassField extends StatelessWidget {
  const GlossipGlassField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.darkText = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final bool darkText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: darkText ? Colors.white : Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: darkText
              ? Colors.black.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.15),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        style: TextStyle(color: darkText ? Colors.black : Colors.white),
        decoration: InputDecoration.collapsed(
          hintText: hint,
          hintStyle: TextStyle(
            color: darkText
                ? Colors.black.withValues(alpha: 0.45)
                : Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

class GlassField extends GlossipGlassField {
  const GlassField({
    super.key,
    required super.controller,
    required super.hint,
    super.obscureText = false,
    super.darkText = false,
    super.onChanged,
  });
}
