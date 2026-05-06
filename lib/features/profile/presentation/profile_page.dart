import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

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
              child: GlossipCard(
                child: Column(
                  children: [
                    const Text(
                      "VOCÊ PRECISA ESTAR LOGADO PARA ACESSAR O PERFIL.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
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
            child: Column(
              children: [
                GlossipCard(
                  child: Column(
                    children: [
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "@${user.username}".toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 32,
                                  ),
                                ),
                                Text(
                                  user.displayName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  user.email ?? "",
                                  style: TextStyle(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (user.personalEmail != null)
                                  Text(
                                    user.personalEmail!,
                                    style: TextStyle(
                                      color: Colors.black.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          GlossipButton(
                            label: "Sair",
                            background: Colors.white,
                            onPressed: () async {
                              await context.read<SessionCubit>().logout();
                              if (context.mounted) {
                                context.go("/");
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: "Fofoquinhas",
                              value: "${myPosts.length}",
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _StatCard(
                              label: "Galeria",
                              value: showInGallery ? "Visível" : "Oculto",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                GlossipCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PERFIL",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _ReadOnlyField(
                        label: "Nome",
                        value: user.firstName ?? "Não informado",
                      ),
                      const SizedBox(height: 16),
                      _ReadOnlyField(
                        label: "Sobrenome",
                        value: user.lastName ?? "Não informado",
                      ),
                      const SizedBox(height: 16),
                      _ReadOnlyField(
                        label: "Email institucional",
                        value: user.email ?? "Não informado",
                      ),
                      const SizedBox(height: 24),
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
                      const SizedBox(height: 20),
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
                const SizedBox(height: 32),
                if (myPosts.isNotEmpty)
                  Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "SUAS PUBLICAÇÕES",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      for (final gossip in myPosts)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
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

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlossipCard(
      shadowOffset: const Offset(8, 8),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 28,
            ),
          ),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

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
