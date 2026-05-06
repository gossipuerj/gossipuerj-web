import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "../../../core/theme/app_breakpoints.dart";
import "../../../domain/models/user_profile.dart";
import "../../../features/auth/presentation/session/session_cubit.dart";
import "../../../features/auth/presentation/session/session_state.dart";
import "../../../shared/layout/page_container.dart";
import "../../../shared/state/mock_app_cubits.dart";
import "../../../shared/widgets/avatar.dart";
import "../../../shared/widgets/glossip_components.dart";
import "profile_cubit.dart";
import "profile_state.dart";
import "../../feed/presentation/widgets/gossip_card.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  final courseController = TextEditingController();
  final avatarUrlController = TextEditingController();
  String gender = "Prefiro não informar";
  String orientation = "Outro";
  bool showInGallery = true;
  bool hydrated = false;

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    courseController.dispose();
    avatarUrlController.dispose();
    super.dispose();
  }

  void _hydrate(ProfileState state) {
    final user = state.user;
    if (user == null || hydrated) {
      return;
    }
    hydrated = true;
    usernameController.text = user.username;
    bioController.text = user.bio ?? "";
    courseController.text = user.course ?? "";
    avatarUrlController.text = user.avatarUrl ?? "";
    gender = user.gender ?? "Prefiro não informar";
    orientation = user.orientation ?? "Outro";
    showInGallery = user.showInGallery;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, sessionState) {
        if (sessionState.user != null) {
          context.read<ProfileCubit>().setUserFromSession();
          hydrated = false;
        }
      },
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
            context.read<ProfileCubit>().clearFeedback();
          }
        },
        builder: (context, profileState) {
          final width = MediaQuery.sizeOf(context).width;
          final isCompact = width < AppBreakpoints.mobile;
          final sessionState = context.watch<SessionCubit>().state;
          final feedCubit = context.watch<FeedCubit>();
          if (profileState.user == null && sessionState.user != null) {
            context.read<ProfileCubit>().setUserFromSession();
          }
          _hydrate(
            profileState.user == null
                ? ProfileState(user: sessionState.user)
                : profileState,
          );
          final user = profileState.user ?? sessionState.user;

          if (user == null) {
            return PageContainer(
              maxWidth: 800,
              padding: EdgeInsets.fromLTRB(
                isCompact ? 16 : 24,
                40,
                isCompact ? 16 : 24,
                40,
              ),
              child: GlossipCard(
                child: Column(
                  children: [
                    Text(
                      "VOCÊ PRECISA ESTAR LOGADO PARA ACESSAR O PERFIL.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: isCompact ? 16 : 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GlossipButton(
                      label: "Ir para Login",
                      onPressed: () => context.go("/login"),
                    ),
                  ],
                ),
              ),
            );
          }

          final myPosts = feedCubit.postsByUser(user.id);

          return PageContainer(
            maxWidth: 900,
            padding: EdgeInsets.fromLTRB(
              isCompact ? 16 : 24,
              isCompact ? 24 : 40,
              isCompact ? 16 : 24,
              40,
            ),
            child: Column(
              children: [
                GlossipCard(
                  child: Column(
                    children: [
                      if (isCompact)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserAvatar(
                              username: user.username,
                              avatarUrl: avatarUrlController.text.isEmpty
                                  ? user.avatarUrl
                                  : avatarUrlController.text,
                              size: 72,
                              square: true,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _ProfileIdentity(
                                user: user,
                                isCompact: true,
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            UserAvatar(
                              username: user.username,
                              avatarUrl: avatarUrlController.text.isEmpty
                                  ? user.avatarUrl
                                  : avatarUrlController.text,
                              size: 96,
                              square: true,
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: _ProfileIdentity(user: user),
                            ),
                          ],
                        ),
                      SizedBox(height: isCompact ? 20 : 24),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: "Fofoquinhas",
                              value: "${myPosts.length}",
                              isCompact: isCompact,
                            ),
                          ),
                          SizedBox(width: isCompact ? 12 : 16),
                          Expanded(
                            child: _StatCard(
                              label: "Galeria",
                              value: showInGallery ? "Visível" : "Oculto",
                              isCompact: isCompact,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isCompact ? 24 : 32),
                GlossipCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PERFIL",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: isCompact ? 20 : 24,
                        ),
                      ),
                      SizedBox(height: isCompact ? 16 : 20),
                      _ReadOnlyField(
                        label: "Nome",
                        value: user.firstName ?? "Não informado",
                        isCompact: isCompact,
                      ),
                      const SizedBox(height: 16),
                      _ReadOnlyField(
                        label: "Sobrenome",
                        value: user.lastName ?? "Não informado",
                        isCompact: isCompact,
                      ),
                      const SizedBox(height: 16),
                      _ReadOnlyField(
                        label: "Email institucional",
                        value: user.email ?? "Não informado",
                        isCompact: isCompact,
                      ),
                      SizedBox(height: isCompact ? 20 : 24),
                      GlossipLabeledTextField(
                        label: "Username",
                        controller: usernameController,
                      ),
                      const SizedBox(height: 16),
                      GlossipLabeledTextField(
                        label: "Curso",
                        controller: courseController,
                      ),
                      const SizedBox(height: 16),
                      GlossipLabeledTextField(
                        label: "Bio",
                        controller: bioController,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      GlossipLabeledTextField(
                        label: "Avatar URL",
                        controller: avatarUrlController,
                      ),
                      const SizedBox(height: 16),
                      GlossipLabeledSelectField(
                        label: "Gênero",
                        value: gender,
                        items: const [
                          "Masculino",
                          "Feminino",
                          "Não-binário",
                          "Outro",
                          "Prefiro não informar",
                        ],
                        onChanged: (value) => setState(() => gender = value),
                      ),
                      const SizedBox(height: 16),
                      GlossipLabeledSelectField(
                        label: "Orientação",
                        value: orientation,
                        items: const [
                          "Heterossexual",
                          "Homossexual",
                          "Lésbica",
                          "Bissexual",
                          "Pansexual",
                          "Outro",
                        ],
                        onChanged: (value) =>
                            setState(() => orientation = value),
                      ),
                      const SizedBox(height: 16),
                      GlossipButton(
                        label: showInGallery
                            ? "Perfil visível na galeria"
                            : "Perfil oculto na galeria",
                        background: showInGallery
                            ? Colors.cyanAccent
                            : const Color(0xFFF0F0F0),
                        onPressed: () =>
                            setState(() => showInGallery = !showInGallery),
                        expanded: true,
                      ),
                      SizedBox(height: isCompact ? 16 : 20),
                      GlossipButton(
                        label: profileState.isSaving
                            ? "Salvando..."
                            : "Salvar alterações",
                        onPressed: profileState.isSaving
                            ? null
                            : () {
                                context.read<ProfileCubit>().updateProfile(
                                  username: usernameController.text.trim(),
                                  course: courseController.text.trim(),
                                  bio: bioController.text.trim(),
                                  avatarUrl: avatarUrlController.text.trim(),
                                  gender: gender,
                                  orientation: orientation,
                                  showInGallery: showInGallery,
                                );
                              },
                        expanded: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isCompact ? 24 : 32),
                GlossipButton(
                  label: "Sair",
                  background: Colors.white,
                  expanded: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 16 : 24,
                    vertical: isCompact ? 10 : 12,
                  ),
                  onPressed: () async {
                    await context.read<SessionCubit>().logout();
                    if (context.mounted) {
                      context.go("/");
                    }
                  },
                ),
                SizedBox(height: isCompact ? 24 : 32),
                if (myPosts.isNotEmpty)
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "SUAS PUBLICAÇÕES",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: isCompact ? 18 : 22,
                          ),
                        ),
                      ),
                      SizedBox(height: isCompact ? 16 : 20),
                      for (final gossip in myPosts)
                        Padding(
                          padding: EdgeInsets.only(bottom: isCompact ? 16 : 24),
                          child: GossipCard(post: gossip),
                        ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileIdentity extends StatelessWidget {
  const _ProfileIdentity({required this.user, this.isCompact = false});

  final UserProfile user;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "@${user.username}".toUpperCase(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: isCompact ? 22 : 32,
          ),
        ),
        Text(
          user.displayName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: isCompact ? 14 : 16,
          ),
        ),
        Text(
          user.email ?? "",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black.withValues(alpha: 0.7),
            fontWeight: FontWeight.w700,
            fontSize: isCompact ? 13 : 14,
          ),
        ),
        if (user.personalEmail != null)
          Text(
            user.personalEmail!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontWeight: FontWeight.w700,
              fontSize: isCompact ? 13 : 14,
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.isCompact = false,
  });

  final String label;
  final String value;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return GlossipCard(
      shadowOffset: const Offset(8, 8),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: isCompact ? 22 : 28,
            ),
          ),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: isCompact ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    this.isCompact = false,
  });

  final String label;
  final String value;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlossipFieldLabel(label),
        const SizedBox(height: 8),
        GlossipInput(
          background: const Color(0xFFF5F5F5),
          child: Text(
            value,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: isCompact ? 14 : 16,
            ),
          ),
        ),
      ],
    );
  }
}
