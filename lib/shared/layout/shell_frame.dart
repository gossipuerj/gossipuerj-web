import "package:flutter/material.dart";

import "../../core/theme/app_breakpoints.dart";
import "../../core/theme/glossip_colors.dart";
import "app_background.dart";

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
    final showMobileNav = width < AppBreakpoints.tablet;
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
                  child: Column(children: [child, const Footer()]),
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(8, 8)),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: "GLOSSIP",
                      style: const TextStyle(
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
                      ? const [
                          BoxShadow(
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

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < AppBreakpoints.tablet;
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
