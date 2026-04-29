import "dart:math" as math;
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:url_launcher/url_launcher.dart";

class GlossipColors {
  static const primary = Color(0xFFFF00FF);
  static const secondary = Color(0xFF00FFFF);
  static const accent = Color(0xFFFFFF00);
  static const background = Color(0xFFFF007F);
  static const card = Colors.white;
  static const black = Colors.black;
}

ThemeData buildTheme() {
  final urbanistFamily = GoogleFonts.urbanist().fontFamily;
  final textTheme = _heavierTextTheme(
    GoogleFonts.urbanistTextTheme(),
  ).apply(bodyColor: Colors.white, displayColor: Colors.white);

  return ThemeData(
    useMaterial3: true,
    fontFamily: urbanistFamily,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: GlossipColors.primary,
      primary: GlossipColors.primary,
      secondary: GlossipColors.secondary,
      surface: Colors.white,
    ),
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
      isDense: true,
    ),
  );
}

TextTheme _heavierTextTheme(TextTheme theme) {
  return theme.copyWith(
    displayLarge: _heavierTextStyle(theme.displayLarge),
    displayMedium: _heavierTextStyle(theme.displayMedium),
    displaySmall: _heavierTextStyle(theme.displaySmall),
    headlineLarge: _heavierTextStyle(theme.headlineLarge),
    headlineMedium: _heavierTextStyle(theme.headlineMedium),
    headlineSmall: _heavierTextStyle(theme.headlineSmall),
    titleLarge: _heavierTextStyle(theme.titleLarge),
    titleMedium: _heavierTextStyle(theme.titleMedium),
    titleSmall: _heavierTextStyle(theme.titleSmall),
    bodyLarge: _heavierTextStyle(theme.bodyLarge),
    bodyMedium: _heavierTextStyle(theme.bodyMedium),
    bodySmall: _heavierTextStyle(theme.bodySmall),
    labelLarge: _heavierTextStyle(theme.labelLarge),
    labelMedium: _heavierTextStyle(theme.labelMedium),
    labelSmall: _heavierTextStyle(theme.labelSmall),
  );
}

TextStyle? _heavierTextStyle(TextStyle? style) {
  if (style == null) {
    return null;
  }

  final fontWeight = _heavierFontWeight(style.fontWeight);
  return style.copyWith(
    fontWeight: fontWeight,
    fontVariations: [FontVariation("wght", _fontWeightValue(fontWeight))],
  );
}

FontWeight _heavierFontWeight(FontWeight? fontWeight) {
  return switch (fontWeight ?? FontWeight.w400) {
    FontWeight.w100 => FontWeight.w600,
    FontWeight.w200 => FontWeight.w600,
    FontWeight.w300 => FontWeight.w600,
    FontWeight.w400 => FontWeight.w600,
    FontWeight.w500 => FontWeight.w700,
    FontWeight.w600 => FontWeight.w700,
    FontWeight.w700 => FontWeight.w800,
    FontWeight.w800 => FontWeight.w900,
    FontWeight.w900 => FontWeight.w900,
    _ => FontWeight.w700,
  };
}

double _fontWeightValue(FontWeight fontWeight) {
  return switch (fontWeight) {
    FontWeight.w100 => 100,
    FontWeight.w200 => 200,
    FontWeight.w300 => 300,
    FontWeight.w400 => 400,
    FontWeight.w500 => 500,
    FontWeight.w600 => 600,
    FontWeight.w700 => 700,
    FontWeight.w800 => 800,
    FontWeight.w900 => 900,
    _ => 700,
  }.toDouble();
}

class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: _DotsPainter())),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.8, -0.6),
                  radius: 0.55,
                  colors: [
                    GlossipColors.secondary.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.85, 0.8),
                  radius: 0.5,
                  colors: [
                    GlossipColors.accent.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = GlossipColors.background;
    canvas.drawRect(Offset.zero & size, background);

    final dotPaint = Paint()..color = Colors.white.withValues(alpha: 0.2);
    const spacing = 60.0;
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        canvas.drawCircle(Offset(x, y), 4.5, dotPaint);
        canvas.drawCircle(Offset(x + 30, y + 30), 4.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ShellFrame extends StatelessWidget {
  const ShellFrame({
    super.key,
    required this.child,
    required this.currentPath,
    required this.isLoggedIn,
    required this.onNavigate,
  });

  final Widget child;
  final String currentPath;
  final bool isLoggedIn;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final showMobileNav = width < 851;

    final navItems = [
      _NavItem("Feed", "/", Icons.home_outlined),
      _NavItem("Crushes", "/crushes", Icons.favorite_border),
      _NavItem("Eventos", "/eventos", Icons.calendar_month_outlined),
      _NavItem("Mensagens", "/messages", Icons.chat_bubble_outline),
      _NavItem(
        isLoggedIn ? "Perfil" : "Login",
        isLoggedIn ? "/profile" : "/login",
        Icons.person_outline,
      ),
    ];

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              _TopNav(
                items: navItems,
                currentPath: currentPath,
                onNavigate: onNavigate,
                visible: !showMobileNav,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [child, const _Footer()]),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: showMobileNav
            ? _BottomNav(
                items: navItems,
                currentPath: currentPath,
                onNavigate: onNavigate,
              )
            : null,
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.path, this.icon);

  final String label;
  final String path;
  final IconData icon;
}

class _TopNav extends StatelessWidget {
  const _TopNav({
    required this.items,
    required this.currentPath,
    required this.onNavigate,
    required this.visible,
  });

  final List<_NavItem> items;
  final String currentPath;
  final ValueChanged<String> onNavigate;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: GlossipColors.accent,
        border: Border(bottom: BorderSide(width: 4, color: Colors.black)),
        boxShadow: [BoxShadow(color: Colors.black, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => onNavigate("/"),
                child: Container(
                  decoration: borderedBoxDecoration(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: "GLOSSIP",
                      style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        letterSpacing: -1.5,
                      ),
                      children: const [
                        TextSpan(
                          text: "UERJ",
                          style: TextStyle(color: GlossipColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Wrap(
                spacing: 18,
                children: [
                  for (final item in items)
                    _TopNavDestination(
                      label: item.label,
                      selected: currentPath == item.path,
                      onTap: () => onNavigate(item.path),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopNavDestination extends StatefulWidget {
  const _TopNavDestination({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TopNavDestination> createState() => _TopNavDestinationState();
}

class _TopNavDestinationState extends State<_TopNavDestination> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final showHover = hovered && !widget.selected;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: showHover ? 1.06 : 1),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: AnimatedRotation(
            turns: showHover ? 0.008 : 0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.selected
                    ? Colors.black
                    : showHover
                    ? const Color(0xFF57FDFF)
                    : Colors.transparent,
                border: Border.all(
                  color: widget.selected || showHover
                      ? Colors.black
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Text(
                widget.label.toUpperCase(),
                style: TextStyle(
                  color: widget.selected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.items,
    required this.currentPath,
    required this.onNavigate,
  });

  final List<_NavItem> items;
  final String currentPath;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: const BoxDecoration(
        color: GlossipColors.accent,
        border: Border(top: BorderSide(color: Colors.black, width: 4)),
        boxShadow: [BoxShadow(color: Colors.black, offset: Offset(0, -4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final item in items)
            GestureDetector(
              onTap: () => onNavigate(item.path),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: currentPath == item.path
                      ? Colors.black
                      : Colors.transparent,
                  border: Border.all(
                    color: currentPath == item.path
                        ? Colors.black
                        : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: currentPath == item.path
                      ? [
                          const BoxShadow(
                            color: GlossipColors.primary,
                            offset: Offset(5, 5),
                          ),
                        ]
                      : null,
                ),
                transform: Matrix4.translationValues(
                  0,
                  currentPath == item.path ? -8 : 0,
                  0,
                ),
                child: Icon(
                  item.icon,
                  color: currentPath == item.path ? Colors.white : Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 850;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, 40, 24, mobile ? 120 : 40),
      decoration: const BoxDecoration(
        color: GlossipColors.accent,
        border: Border(top: BorderSide(color: Colors.black, width: 4)),
      ),
      child: Center(
        child: Text(
          "© 2026 GlossipUerj. Feito com 🔥 para o campus.".toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: mobile ? 14 : 18,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class PageContainer extends StatelessWidget {
  const PageContainer({
    super.key,
    required this.child,
    this.maxWidth = 1100,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

BoxDecoration borderedBoxDecoration({
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

class ArtPopCard extends StatelessWidget {
  const ArtPopCard({
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
      decoration: borderedBoxDecoration(
        color: color,
        shadowColor: shadowColor,
        shadowOffset: shadowOffset,
      ),
      child: child,
    );
  }
}

class HoverArtPopCard extends StatefulWidget {
  const HoverArtPopCard({
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
  State<HoverArtPopCard> createState() => _HoverArtPopCardState();
}

class _HoverArtPopCardState extends State<HoverArtPopCard> {
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

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.rotation = -0.02});

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
    final button = Material(
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
    return button;
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

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

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.username,
    this.avatarUrl,
    this.avatarBytes,
    this.square = false,
    this.size = 64,
    this.background,
  });

  final String username;
  final String? avatarUrl;
  final Uint8List? avatarBytes;
  final bool square;
  final double size;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final radius = square ? 0.0 : size / 2;
    final decoration = BoxDecoration(
      color: background ?? const Color(0xFFEEEEEE),
      border: Border.all(color: Colors.black, width: square ? 4 : 3),
      borderRadius: BorderRadius.circular(radius),
      gradient: avatarBytes == null && avatarUrl == null
          ? const LinearGradient(
              colors: [GlossipColors.primary, GlossipColors.secondary],
            )
          : null,
      image: avatarBytes != null
          ? DecorationImage(image: MemoryImage(avatarBytes!), fit: BoxFit.cover)
          : avatarUrl != null
          ? DecorationImage(image: NetworkImage(avatarUrl!), fit: BoxFit.cover)
          : null,
    );
    return Container(
      width: size,
      height: size,
      decoration: decoration,
      alignment: Alignment.center,
      child: avatarBytes == null && avatarUrl == null
          ? Text(
              username.isEmpty ? "@" : username[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.32,
                fontWeight: FontWeight.w900,
              ),
            )
          : null,
    );
  }
}

Future<void> openInstagram(String handle) async {
  final sanitized = handle.replaceAll("@", "");
  final uri = Uri.parse("https://instagram.com/$sanitized");
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

Color eventCategoryColor(String category) {
  switch (category) {
    case "Social":
      return const Color(0xFFFF4D4D);
    case "Acadêmico":
      return GlossipColors.secondary;
    case "Esporte":
      return const Color(0xFF4D94FF);
    case "Cultura":
      return const Color(0xFFB366FF);
    default:
      return Colors.black;
  }
}

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

double rotationDegrees(double degrees) => degrees * math.pi / 180;
