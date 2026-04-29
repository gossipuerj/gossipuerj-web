import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../core/theme/glossip_colors.dart";
import "../../../domain/models/user_profile.dart";
import "../../../shared/layout/page_container.dart";
import "../../../shared/providers/app_providers.dart";
import "../../../shared/seed/mock_seed_data.dart";
import "../../../shared/utils/avatar_picker.dart";
import "../../../shared/widgets/art_pop_card.dart";
import "../../../shared/widgets/avatar.dart";
import "../../../shared/widgets/buttons.dart";
import "../../../shared/widgets/form_fields.dart";
import "../../../shared/widgets/labels.dart";
import "../../feed/presentation/widgets/gossip_card.dart";

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bioController = TextEditingController();
  final instagramController = TextEditingController();
  String course = mockUser.course ?? "Não informado";
  String gender = mockUser.gender ?? "Não informado";
  String orientation = mockUser.orientation ?? "Não informado";
  bool showInGallery = mockUser.showInGallery;
  Uint8List? avatarBytes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ref.read(sessionControllerProvider).currentUser;
    if (user != null &&
        firstNameController.text.isEmpty &&
        lastNameController.text.isEmpty) {
      _hydrateForm(user);
    }
  }

  void _hydrateForm(UserProfile user) {
    firstNameController.text = user.firstName ?? "";
    lastNameController.text = user.lastName ?? "";
    bioController.text = user.bio ?? "";
    instagramController.text = user.instagram ?? "";
    course = user.course ?? "Não informado";
    gender = user.gender ?? "Não informado";
    orientation = user.orientation ?? "Não informado";
    showInGallery = user.showInGallery;
    avatarBytes = user.avatarBytes;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    bioController.dispose();
    instagramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider);
    final profiles = ref.watch(profilesControllerProvider);
    final feed = ref.watch(feedControllerProvider);
    final user = session.currentUser;
    if (user == null) {
      return PageContainer(
        maxWidth: 800,
        child: ArtPopCard(
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

    final myPosts = feed.postsByUser(user.id);
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 600;

    return PageContainer(
      maxWidth: 800,
      child: Column(
        children: [
          ArtPopCard(
            padding: EdgeInsets.fromLTRB(
              compact ? 20 : 40,
              compact ? 60 : 40,
              compact ? 20 : 40,
              40,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: GlossipButton(
                    label: "Sair",
                    background: Colors.white,
                    onPressed: () async {
                      await ref.read(sessionControllerProvider).logout();
                      if (context.mounted) {
                        context.go("/");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Logout simulado (MOCK)"),
                          ),
                        );
                      }
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Flex(
                      direction: compact ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: compact
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        UserAvatar(
                          username: user.username,
                          avatarUrl: user.avatarUrl,
                          avatarBytes: avatarBytes ?? user.avatarBytes,
                          size: 120,
                          square: true,
                        ),
                        SizedBox(
                          width: compact ? 0 : 32,
                          height: compact ? 20 : 0,
                        ),
                        if (compact)
                          _ProfileHeaderText(
                            username: user.username,
                            compact: true,
                          )
                        else
                          Expanded(
                            child: _ProfileHeaderText(
                              username: user.username,
                              compact: false,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              final vertical = constraints.maxWidth < 600;
              final postsCard = ArtPopCard(
                shadowOffset: const Offset(8, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${myPosts.length}",
                      style: const TextStyle(
                        color: GlossipColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 48,
                      ),
                    ),
                    const Text(
                      "FOFOCAS POSTADAS",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              );
              final statusCard = ArtPopCard(
                shadowOffset: const Offset(8, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      myPosts.isEmpty ? "Novo" : "Ativo",
                      style: const TextStyle(
                        color: GlossipColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                      ),
                    ),
                    const Text(
                      "STATUS",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              );
              return vertical
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        postsCard,
                        const SizedBox(height: 20),
                        statusCard,
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: postsCard),
                        const SizedBox(width: 20),
                        Expanded(child: statusCard),
                      ],
                    );
            },
          ),
          const SizedBox(height: 40),
          ArtPopCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.shield_outlined, color: Colors.black),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "PRIVACIDADE DA GALERIA",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Escolha se deseja que seu perfil seja listado na página de Crushes para outros alunos.",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 24),
                GlossipButton(
                  label: showInGallery
                      ? "Perfil Visível na Galeria"
                      : "Perfil Oculto na Galeria",
                  background: showInGallery
                      ? Colors.cyanAccent
                      : const Color(0xFFF0F0F0),
                  onPressed: () =>
                      setState(() => showInGallery = !showInGallery),
                  expanded: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Align(
            alignment: Alignment.centerLeft,
            child: SectionLabel("⚙️ Configurações de Identidade"),
          ),
          const SizedBox(height: 20),
          ArtPopCard(
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final vertical = constraints.maxWidth < 600;
                    final first = LabeledTextField(
                      label: "Nome",
                      controller: firstNameController,
                    );
                    final second = LabeledTextField(
                      label: "Sobrenome",
                      controller: lastNameController,
                    );
                    return vertical
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              first,
                              const SizedBox(height: 20),
                              second,
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(child: first),
                              const SizedBox(width: 20),
                              Expanded(child: second),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 20),
                LabeledTextField(
                  label: "Bio / Descrição",
                  controller: bioController,
                  maxLines: 4,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const FieldLabel("Foto de Perfil"),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (avatarBytes != null || user.avatarUrl != null)
                        UserAvatar(
                          username: user.username,
                          avatarUrl: user.avatarUrl,
                          avatarBytes: avatarBytes,
                          size: 80,
                          square: true,
                        ),
                      GlossipButton(
                        label: "Selecionar imagem",
                        onPressed: () async {
                          try {
                            final selected = await pickCompressedAvatar();
                            if (selected != null) {
                              setState(
                                () => avatarBytes = profiles.buildAvatarBytes(
                                  selected,
                                ),
                              );
                            }
                          } on AvatarTooLargeException {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "A imagem é muito grande! Por favor, escolha uma imagem menor que 2MB.",
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DropdownGroup(
                  label: "Seu Curso",
                  value: course,
                  items: const ["Não informado", ...uerjCourses],
                  onChanged: (value) => setState(() => course = value),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final vertical = constraints.maxWidth < 600;
                    final one = DropdownGroup(
                      label: "Gênero",
                      value: gender,
                      items: const [
                        "Não informado",
                        "Masculino",
                        "Feminino",
                        "Não-binário",
                        "Outro",
                      ],
                      onChanged: (value) => setState(() => gender = value),
                    );
                    final two = DropdownGroup(
                      label: "Orientação Sexual",
                      value: orientation,
                      items: const [
                        "Não informado",
                        "Heterossexual",
                        "Homossexual",
                        "Bissexual",
                        "Pansexual",
                        "Asexual",
                        "Outra",
                      ],
                      onChanged: (value) => setState(() => orientation = value),
                    );
                    return vertical
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [one, const SizedBox(height: 20), two],
                          )
                        : Row(
                            children: [
                              Expanded(child: one),
                              const SizedBox(width: 20),
                              Expanded(child: two),
                            ],
                          );
                  },
                ),
                const SizedBox(height: 20),
                LabeledTextField(
                  label: "Instagram (@)",
                  controller: instagramController,
                ),
                const SizedBox(height: 20),
                GlossipButton(
                  label: profiles.isSavingProfile
                      ? "Salvando..."
                      : "Salvar Alterações",
                  onPressed: profiles.isSavingProfile
                      ? null
                      : () async {
                          final updatedUser = user.copyWith(
                            firstName: firstNameController.text.trim(),
                            lastName: lastNameController.text.trim(),
                            bio: bioController.text.trim(),
                            instagram: instagramController.text.trim(),
                            course: course,
                            gender: gender,
                            orientation: orientation,
                            showInGallery: showInGallery,
                            avatarBytes: avatarBytes,
                          );
                          await ref
                              .read(profilesControllerProvider)
                              .updateProfile(updatedUser);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Perfil atualizado!\nBio: ${bioController.text.trim()}\nGaleria: ${showInGallery ? "Visível" : "Oculto"}",
                                ),
                              ),
                            );
                          }
                        },
                  expanded: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Align(
            alignment: Alignment.centerLeft,
            child: SectionLabel("Suas Publicações"),
          ),
          const SizedBox(height: 20),
          if (myPosts.isEmpty)
            const ArtPopCard(
              child: Center(
                child: Text(
                  "VOCÊ AINDA NÃO POSTOU NENHUMA FOFOCA. O QUE ESTÁ ESPERANDO?",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            )
          else
            Column(
              children: [
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
  }
}

class _ProfileHeaderText extends StatelessWidget {
  const _ProfileHeaderText({required this.username, required this.compact});

  final String username;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: compact
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          "@$username".toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 40,
          ),
        ),
        Container(
          color: Colors.yellow,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: const Text(
            "Membro da comunidade GlossipUerj",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}
