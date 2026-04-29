import "dart:typed_data";

import "package:flutter/material.dart";

import "../../core/theme/glossip_colors.dart";

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
