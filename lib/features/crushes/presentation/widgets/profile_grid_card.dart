import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "../../../../core/theme/glossip_colors.dart";
import "../../../../domain/models/user_profile.dart";
import "../../../../features/auth/presentation/session/session_cubit.dart";
import "../../../../shared/state/mock_app_cubits.dart";
import "../../../../shared/utils/external_launchers.dart";
import "../../../../shared/widgets/avatar.dart";
import "../../../../shared/widgets/glossip_components.dart";

class ProfileGridCard extends StatelessWidget {
  const ProfileGridCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final profilesState = context.watch<ProfilesCubit>().state;
    final sessionState = context.watch<SessionCubit>().state;
    final isOwnProfile = profile.username == sessionState.user?.username;
    final liked = profilesState.likedProfiles.contains(profile.username);

    return GlossipCard(
      padding: const EdgeInsets.all(16),
      shadowOffset: const Offset(8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: UserAvatar(
              username: profile.username,
              avatarUrl: profile.avatarUrl,
              avatarBytes: profile.avatarBytes,
              square: true,
              size: double.infinity,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.displayName.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          Text(
            "@${profile.username}",
            style: const TextStyle(
              color: GlossipColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              GlossipTag(text: profile.course ?? "Curso não inf."),
              GlossipTag(text: profile.gender ?? "Não informado"),
              GlossipTag(text: profile.orientation ?? "Não informado"),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              if (profile.instagram != null)
                Expanded(
                  child: GlossipIconTileButton(
                    icon: Icons.camera_alt_outlined,
                    onTap: () => openInstagram(profile.instagram!),
                  ),
                ),
              if (profile.instagram != null) const SizedBox(width: 10),
              if (!isOwnProfile)
                Expanded(
                  child: GlossipIconTileButton(
                    icon: Icons.chat_bubble_outline,
                    onTap: () =>
                        context.go("/messages?user=${profile.username}"),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (isOwnProfile)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: const Text(
                "VOCÊ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            )
          else
            GlossipButton(
              label: liked ? "❤️ Interessado" : "🤍 Dar Like",
              background: liked ? GlossipColors.primary : Colors.white,
              foreground: liked ? Colors.white : Colors.black,
              onPressed: !sessionState.isAuthenticated
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Você precisa estar logado para dar like em um perfil!",
                          ),
                        ),
                      );
                    }
                  : () => context.read<ProfilesCubit>().toggleLikedProfile(
                      profile.username,
                    ),
              expanded: true,
            ),
        ],
      ),
    );
  }
}
