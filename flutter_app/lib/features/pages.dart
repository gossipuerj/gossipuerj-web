import "dart:typed_data";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:image/image.dart" as img;
import "package:intl/intl.dart";

import "../app/router.dart";
import "../core/design_system.dart";
import "../core/mock_data.dart";
import "../core/models.dart";

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final targetController = TextEditingController();
  final contentController = TextEditingController();
  String selectedCategory = "Todos";
  String composerCategory = "Fofoca";

  @override
  void dispose() {
    targetController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(appControllerProvider);
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 850;
    final categories = const ["Todos", "Fofoca", "Desabafo", "Paquera"];
    final filtered = selectedCategory == "Todos"
        ? controller.gossips
        : controller.gossips
              .where((item) => item.category == selectedCategory)
              .toList();

    return PageContainer(
      maxWidth: 1100,
      padding: EdgeInsets.fromLTRB(
        isCompact ? 16 : 24,
        isCompact ? 80 : 100,
        isCompact ? 16 : 24,
        40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flex(
            direction: isCompact ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: isCompact
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: isCompact ? 0 : 1,
                child: Column(
                  crossAxisAlignment: isCompact
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: isCompact ? TextAlign.center : TextAlign.left,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: isCompact ? 44 : 68,
                          height: 0.95,
                        ),
                        children: [
                          TextSpan(text: "O que está rolando na "),
                          TextSpan(
                            text: "UERJ",
                            style: TextStyle(
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    GlossipColors.primary,
                                    GlossipColors.secondary,
                                  ],
                                ).createShader(Rect.fromLTWH(0, 0, 180, 60)),
                            ),
                          ),
                          TextSpan(text: "?"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Transform.rotate(
                      angle: -0.02,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: GlossipColors.accent,
                          border: Border.all(color: Colors.black, width: 4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(6, 6),
                            ),
                          ],
                        ),
                        child: const Text(
                          "FOFOCAS ANÔNIMAS, SEGREDOS E CRUSHES DO CAMPUS.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32, width: 32),
              const GretchenBlob(),
            ],
          ),
          const SizedBox(height: 40),
          ArtPopCard(
            shadowOffset: const Offset(12, 12),
            child: Column(
              children: [
                GlossipInput(
                  child: TextField(
                    controller: targetController,
                    decoration: const InputDecoration.collapsed(
                      hintText:
                          "Para quem é? (Ex: @username, @curso, Alguém do Bandejão...)",
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GlossipInput(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: contentController,
                    maxLength: 280,
                    maxLines: 5,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration.collapsed(
                      hintText: "O que está acontecendo no campus?",
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 3),
                    ),
                  ),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 8,
                    spacing: 12,
                    children: [
                      _DropdownField(
                        value: composerCategory,
                        items: const ["Fofoca", "Desabafo", "Paquera"],
                        onChanged: (value) =>
                            setState(() => composerCategory = value),
                      ),
                      Text(
                        "${contentController.text.length}/280",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      GlossipButton(
                        label: "Publicar Anonimamente",
                        onPressed: contentController.text.trim().isEmpty
                            ? null
                            : () async {
                                await ref
                                    .read(appControllerProvider)
                                    .postGossip(
                                      target: targetController.text.trim(),
                                      content: contentController.text.trim(),
                                      category: composerCategory,
                                    );
                                targetController.clear();
                                contentController.clear();
                                setState(() {});
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Publicação enviada anonimamente!",
                                      ),
                                    ),
                                  );
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Flex(
            direction: width < 600 ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: width < 600
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
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
                  ),
                ),
              ),
              const SizedBox(height: 16, width: 16),
              if (width < 600)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
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
                            onPressed: () =>
                                setState(() => selectedCategory = category),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                              onPressed: () =>
                                  setState(() => selectedCategory = category),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 32),
          Column(
            children: [
              if (filtered.isEmpty)
                ArtPopCard(
                  child: const Center(
                    child: Text(
                      "NENHUMA FOFOCA ENCONTRADA NESTA CATEGORIA.",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              for (final gossip in filtered)
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

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool isLogin = true;
  String error = "";
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(appControllerProvider);
    return PageContainer(
      maxWidth: 450,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 24,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text.rich(
                TextSpan(
                  text: "GLOSSIP",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                  children: const [
                    TextSpan(
                      text: "UERJ",
                      style: TextStyle(color: GlossipColors.primary),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                isLogin ? "Bem-vindo de volta" : "Criar sua conta",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isLogin
                    ? "Acesse para demonstrar interesse nos crushes."
                    : "Use seu @ do Instagram como usuário.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    " @ DO INSTAGRAM",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _GlassField(
                    controller: usernameController,
                    hint: "@seu_insta",
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "SENHA",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _GlassField(
                    controller: passwordController,
                    hint: "••••••••",
                    obscureText: true,
                  ),
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      error,
                      style: const TextStyle(color: Color(0xFFFF4444)),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: controller.isAuthenticating
                          ? null
                          : () async {
                              setState(() => error = "");
                              final username = usernameController.text.trim();
                              final password = passwordController.text.trim();
                              final ok = isLogin
                                  ? await ref
                                        .read(appControllerProvider)
                                        .login(
                                          username: username,
                                          password: password,
                                        )
                                  : await ref
                                        .read(appControllerProvider)
                                        .register(
                                          username: username,
                                          password: password,
                                        );
                              if (!context.mounted) {
                                return;
                              }
                              if (ok && isLogin) {
                                context.go("/crushes");
                              } else if (ok) {
                                setState(() => isLogin = true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Conta criada! Agora faça o login.",
                                    ),
                                  ),
                                );
                              } else {
                                setState(() => error = "Ocorreu um erro");
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              GlossipColors.primary,
                              GlossipColors.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          controller.isAuthenticating
                              ? "Carregando..."
                              : (isLogin ? "Entrar" : "Registrar"),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    isLogin ? "Não tem conta? " : "Já tem conta? ",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin ? "Crie agora" : "Faça login",
                      style: const TextStyle(
                        color: GlossipColors.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => context.go("/"),
                child: Text(
                  "Voltar ao Feed",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CrushesPage extends ConsumerStatefulWidget {
  const CrushesPage({super.key});

  @override
  ConsumerState<CrushesPage> createState() => _CrushesPageState();
}

class _CrushesPageState extends ConsumerState<CrushesPage> {
  final searchController = TextEditingController();
  String selectedCourse = "Todos";
  String selectedGender = "Todos";
  String selectedOrientation = "Todos";

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(appControllerProvider);
    final search = searchController.text.toLowerCase();
    final filtered = controller.profiles.where((profile) {
      if (controller.isLoggedIn &&
          profile.username == controller.currentUser?.username) {
        return false;
      }
      if (!profile.showInGallery) {
        return false;
      }
      final matchesSearch =
          profile.username.toLowerCase().contains(search) ||
          (profile.firstName ?? "").toLowerCase().contains(search) ||
          (profile.lastName ?? "").toLowerCase().contains(search);
      final profileCourse = profile.course ?? "";
      final profileGender = controller.normalizedGender(profile.gender ?? "");
      final profileOrientation = controller.normalizedOrientation(
        profile.orientation ?? "",
      );

      final matchesCourse =
          selectedCourse == "Todos" || profileCourse == selectedCourse;
      final matchesGender =
          selectedGender == "Todos" || profileGender == selectedGender;
      final matchesOrientation =
          selectedOrientation == "Todos" ||
          profileOrientation == selectedOrientation;
      return matchesSearch &&
          matchesCourse &&
          matchesGender &&
          matchesOrientation;
    }).toList();

    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1000
        ? 4
        : width >= 700
        ? 3
        : width >= 500
        ? 2
        : 1;

    return PageContainer(
      maxWidth: 1000,
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
      child: Column(
        children: [
          const _HeroTitle(
            titleStart: "Galeria de ",
            titleHighlight: "Crushes",
            subtitle:
                "Encontre outros alunos da UERJ e demonstre seu interesse.",
            gradient2: true,
          ),
          const SizedBox(height: 32),
          if (!controller.isLoggedIn)
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: ArtPopCard(
                color: GlossipColors.accent,
                shadowOffset: const Offset(8, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Você precisa estar logado com seu @ do Instagram para dar like nos perfis.",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GlossipButton(
                      label: "Entrar / Registrar",
                      background: Colors.black,
                      foreground: Colors.white,
                      onPressed: () => context.go("/login"),
                    ),
                  ],
                ),
              ),
            ),
          ArtPopCard(
            child: Column(
              children: [
                GlossipInput(
                  padding: const EdgeInsets.only(
                    left: 14,
                    right: 14,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.black),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration.collapsed(
                            hintText: "Procurar por nome ou @...",
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final vertical = constraints.maxWidth < 768;
                    final children = [
                      Expanded(
                        child: _DropdownGroup(
                          label: "Curso",
                          value: selectedCourse,
                          items: const ["Todos", ...uerjCourses],
                          onChanged: (value) =>
                              setState(() => selectedCourse = value),
                        ),
                      ),
                      Expanded(
                        child: _DropdownGroup(
                          label: "Gênero",
                          value: selectedGender,
                          items: genders,
                          onChanged: (value) =>
                              setState(() => selectedGender = value),
                        ),
                      ),
                      Expanded(
                        child: _DropdownGroup(
                          label: "Orientação",
                          value: selectedOrientation,
                          items: orientations,
                          onChanged: (value) =>
                              setState(() => selectedOrientation = value),
                        ),
                      ),
                    ];
                    return vertical
                        ? Column(
                            children: [
                              for (final child in children) ...[
                                child,
                                const SizedBox(height: 16),
                              ],
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              children[0],
                              const SizedBox(width: 20),
                              children[1],
                              const SizedBox(width: 20),
                              children[2],
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 4)),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: Text(
                "${filtered.length} ${filtered.length == 1 ? "PERFIL ENCONTRADO" : "PERFIS ENCONTRADOS"}",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (filtered.isEmpty)
            const ArtPopCard(
              child: Center(
                child: Text(
                  "NENHUM PERFIL CORRESPONDE AOS SEUS FILTROS. TENTE OUTRA BUSCA!",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) =>
                  ProfileGridCard(profile: filtered[index]),
            ),
        ],
      ),
    );
  }
}

class MessagesPage extends ConsumerStatefulWidget {
  const MessagesPage({super.key, this.initialUsername});

  final String? initialUsername;

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  ConversationSummary? selectedChat;
  final newMessageController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _selectInitialChat());
  }

  @override
  void didUpdateWidget(covariant MessagesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialUsername != widget.initialUsername) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _selectInitialChat());
    }
  }

  void _selectInitialChat() {
    final username = widget.initialUsername;
    if (username == null || username.isEmpty) {
      return;
    }
    final conversation = ref
        .read(appControllerProvider)
        .openOrCreateConversation(username);
    setState(() => selectedChat = conversation);
  }

  @override
  void dispose() {
    newMessageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(appControllerProvider);
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 600;
    final activeMessages = selectedChat == null
        ? const <ChatMessage>[]
        : controller.chatHistory[selectedChat!.id] ?? const [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });

    return PageContainer(
      maxWidth: 900,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      child: selectedChat == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _PageHeader(
                  title: "Suas Conversas",
                  subtitle: "Diga algo para seus crushes e amigos da UERJ.",
                ),
                const SizedBox(height: 32),
                for (final conversation in controller.conversations)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedChat = conversation),
                      child: ArtPopCard(
                        shadowColor: conversation.unread
                            ? GlossipColors.primary
                            : Colors.black,
                        shadowOffset: const Offset(8, 8),
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            UserAvatar(
                              username: conversation.user,
                              square: true,
                              size: 64,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "@${conversation.user}".toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        conversation.timeLabel,
                                        style: TextStyle(
                                          color: Colors.black.withValues(
                                            alpha: 0.6,
                                          ),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    conversation.lastMessage,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (conversation.unread)
                              Container(
                                width: 14,
                                height: 14,
                                decoration: borderedBoxDecoration(
                                  color: GlossipColors.primary,
                                  borderWidth: 2,
                                  shadowOffset: const Offset(3, 3),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : Container(
              height: mobile
                  ? MediaQuery.sizeOf(context).height - 90
                  : MediaQuery.sizeOf(context).height * 0.75,
              decoration: borderedBoxDecoration(
                color: Colors.white,
                shadowOffset: mobile ? Offset.zero : const Offset(12, 12),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: GlossipColors.accent,
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 4),
                      ),
                    ),
                    child: Row(
                      children: [
                        _SquareIconButton(
                          icon: Icons.arrow_back,
                          onTap: () => setState(() => selectedChat = null),
                        ),
                        const SizedBox(width: 16),
                        UserAvatar(
                          username: selectedChat!.user,
                          square: true,
                          size: 44,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "@${selectedChat!.user}".toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                              const Text(
                                "online",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.more_vert, color: Colors.black),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: const Color(0xFFF0F0F0),
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(24),
                        itemCount: activeMessages.length,
                        itemBuilder: (context, index) {
                          final message = activeMessages[index];
                          final mine = message.sender == ChatSender.me;
                          return Align(
                            alignment: mine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: mobile ? width * 0.78 : 420,
                              ),
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: borderedBoxDecoration(
                                color: mine
                                    ? GlossipColors.primary
                                    : Colors.white,
                                shadowOffset: const Offset(4, 4),
                                borderWidth: 3,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.text,
                                    style: TextStyle(
                                      color: mine ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      message.timeLabel,
                                      style: TextStyle(
                                        color:
                                            (mine ? Colors.white : Colors.black)
                                                .withValues(alpha: 0.8),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.black, width: 4),
                      ),
                    ),
                    child: Row(
                      children: [
                        const _SquareIconButton(
                          icon: Icons.emoji_emotions_outlined,
                        ),
                        const SizedBox(width: 8),
                        const _SquareIconButton(icon: Icons.attach_file),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GlossipInput(
                            child: TextField(
                              controller: newMessageController,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration.collapsed(
                                hintText: "Mensagem",
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _SquareIconButton(
                          icon: Icons.send,
                          background: GlossipColors.secondary,
                          onTap: newMessageController.text.trim().isEmpty
                              ? null
                              : () {
                                  ref
                                      .read(appControllerProvider)
                                      .sendMessage(
                                        conversationId: selectedChat!.id,
                                        text: newMessageController.text.trim(),
                                      );
                                  newMessageController.clear();
                                  setState(() {});
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

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
    final user = ref.read(appControllerProvider).currentUser;
    if (user != null &&
        firstNameController.text.isEmpty &&
        lastNameController.text.isEmpty) {
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
    final controller = ref.watch(appControllerProvider);
    final user = controller.currentUser;
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

    final myPosts = controller.postsByCurrentUser();
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
                      await ref.read(appControllerProvider).logout();
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: compact
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                "@${user.username}".toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40,
                                ),
                              ),
                              Container(
                                color: GlossipColors.accent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                child: const Text(
                                  "Membro da comunidade GlossipUerj",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
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
              final cards = [
                Expanded(
                  child: ArtPopCard(
                    shadowOffset: const Offset(8, 8),
                    child: Column(
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
                  ),
                ),
                Expanded(
                  child: ArtPopCard(
                    shadowOffset: const Offset(8, 8),
                    child: Column(
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
                  ),
                ),
              ];
              return vertical
                  ? Column(
                      children: [
                        cards[0],
                        const SizedBox(height: 20),
                        cards[1],
                      ],
                    )
                  : Row(
                      children: [cards[0], const SizedBox(width: 20), cards[1]],
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                GlossipButton(
                  label: showInGallery
                      ? "Perfil Visível na Galeria"
                      : "Perfil Oculto na Galeria",
                  background: showInGallery
                      ? GlossipColors.secondary
                      : const Color(0xFFF0F0F0),
                  onPressed: () =>
                      setState(() => showInGallery = !showInGallery),
                  expanded: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: const SectionLabel("⚙️ Configurações de Identidade"),
          ),
          const SizedBox(height: 20),
          ArtPopCard(
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final vertical = constraints.maxWidth < 600;
                    final first = Expanded(
                      child: _LabeledTextField(
                        label: "Nome",
                        controller: firstNameController,
                      ),
                    );
                    final second = Expanded(
                      child: _LabeledTextField(
                        label: "Sobrenome",
                        controller: lastNameController,
                      ),
                    );
                    return vertical
                        ? Column(
                            children: [
                              first,
                              const SizedBox(height: 20),
                              second,
                            ],
                          )
                        : Row(
                            children: [
                              first,
                              const SizedBox(width: 20),
                              second,
                            ],
                          );
                  },
                ),
                const SizedBox(height: 20),
                _LabeledTextField(
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
                    border: Border.all(
                      color: Colors.black,
                      width: 3,
                      style: BorderStyle.solid,
                    ),
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
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            withData: true,
                          );
                          if (result == null ||
                              result.files.single.bytes == null) {
                            return;
                          }
                          final file = result.files.single.bytes!;
                          if (file.length > 2 * 1024 * 1024) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "A imagem é muito grande! Por favor, escolha uma imagem menor que 2MB.",
                                  ),
                                ),
                              );
                            }
                            return;
                          }
                          final decoded = img.decodeImage(file);
                          if (decoded == null) {
                            return;
                          }
                          final resized = img.copyResize(
                            decoded,
                            width: 400,
                            height: 400,
                            maintainAspect: true,
                          );
                          final jpg = Uint8List.fromList(
                            img.encodeJpg(resized, quality: 70),
                          );
                          setState(() => avatarBytes = jpg);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _DropdownGroup(
                  label: "Seu Curso",
                  value: course,
                  items: const ["Não informado", ...uerjCourses],
                  onChanged: (value) => setState(() => course = value),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final vertical = constraints.maxWidth < 600;
                    final one = Expanded(
                      child: _DropdownGroup(
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
                      ),
                    );
                    final two = Expanded(
                      child: _DropdownGroup(
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
                        onChanged: (value) =>
                            setState(() => orientation = value),
                      ),
                    );
                    return vertical
                        ? Column(
                            children: [one, const SizedBox(height: 20), two],
                          )
                        : Row(children: [one, const SizedBox(width: 20), two]);
                  },
                ),
                const SizedBox(height: 20),
                _LabeledTextField(
                  label: "Instagram (@)",
                  controller: instagramController,
                ),
                const SizedBox(height: 20),
                GlossipButton(
                  label: controller.isSavingProfile
                      ? "Salvando..."
                      : "Salvar Alterações",
                  onPressed: controller.isSavingProfile
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
                              .read(appControllerProvider)
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
          Align(
            alignment: Alignment.centerLeft,
            child: const SectionLabel("Suas Publicações"),
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

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends ConsumerState<EventsPage> {
  DateTime currentDate = DateTime(2026, 4, 1);
  String selectedDate = "2026-04-10";

  void _moveMonth(int delta) {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + delta, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(appControllerProvider);
    final width = MediaQuery.sizeOf(context).width;
    final isStacked = width < 1000;
    final monthNames = [
      "Janeiro",
      "Fevereiro",
      "Março",
      "Abril",
      "Maio",
      "Junho",
      "Julho",
      "Agosto",
      "Setembro",
      "Outubro",
      "Novembro",
      "Dezembro",
    ];

    final year = currentDate.year;
    final month = currentDate.month;
    final totalDays = DateUtils.getDaysInMonth(year, month);
    final startDay = DateTime(year, month, 1).weekday % 7;
    final selectedEvents =
        controller.events[selectedDate] ?? const <UniversityEvent>[];

    return PageContainer(
      maxWidth: 1100,
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
      child: Column(
        children: [
          const _HeroTitle(
            titleStart: "Calendário de ",
            titleHighlight: "Eventos",
            subtitle: "Fique por dentro de tudo o que acontece na UERJ.",
          ),
          const SizedBox(height: 50),
          Flex(
            direction: isStacked ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ArtPopCard(
                  padding: EdgeInsets.all(width < 600 ? 16 : 32),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _SquareIconButton(
                            icon: Icons.chevron_left,
                            onTap: () => _moveMonth(-1),
                          ),
                          Expanded(
                            child: Text(
                              "${monthNames[month - 1]} $year".toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: width < 600 ? 24 : 32,
                              ),
                            ),
                          ),
                          _SquareIconButton(
                            icon: Icons.chevron_right,
                            onTap: () => _moveMonth(1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          for (final day in [
                            "Dom",
                            "Seg",
                            "Ter",
                            "Qua",
                            "Qui",
                            "Sex",
                            "Sab",
                          ])
                            Expanded(
                              child: Text(
                                day,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: totalDays + startDay,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: width < 600 ? 6 : 12,
                          mainAxisSpacing: width < 600 ? 6 : 12,
                        ),
                        itemBuilder: (context, index) {
                          if (index < startDay) {
                            return const SizedBox.shrink();
                          }
                          final day = index - startDay + 1;
                          final dateKey =
                              "$year-${month.toString().padLeft(2, "0")}-${day.toString().padLeft(2, "0")}";
                          final selected = dateKey == selectedDate;
                          final hasEvents =
                              (controller.events[dateKey] ?? const [])
                                  .isNotEmpty;
                          return GestureDetector(
                            onTap: () => setState(() => selectedDate = dateKey),
                            child: Container(
                              decoration: borderedBoxDecoration(
                                color: selected ? Colors.black : Colors.white,
                                shadowColor: selected
                                    ? GlossipColors.primary
                                    : Colors.black,
                                shadowOffset: selected
                                    ? const Offset(8, 8)
                                    : Offset.zero,
                                borderWidth: hasEvents ? 4 : 3,
                              ),
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    "$day",
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: width < 600 ? 14 : 18,
                                    ),
                                  ),
                                  if (hasEvents)
                                    Positioned(
                                      bottom: 8,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: borderedBoxDecoration(
                                          color: GlossipColors.secondary,
                                          borderWidth: 2,
                                          shadowOffset: const Offset(2, 2),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: isStacked ? 0 : 32, height: isStacked ? 24 : 0),
              SizedBox(
                width: isStacked ? double.infinity : 400,
                child: ArtPopCard(
                  padding: EdgeInsets.all(width < 600 ? 24 : 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: GlossipColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "EVENTOS DO DIA ${selectedDate.split("-").reversed.join("/")}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          _SquareIconButton(
                            icon: Icons.add,
                            background: GlossipColors.secondary,
                            onTap: () async {
                              final result = await showDialog<UniversityEvent>(
                                context: context,
                                builder: (context) =>
                                    AddEventDialog(selectedDate: selectedDate),
                              );
                              if (result != null) {
                                ref
                                    .read(appControllerProvider)
                                    .addEvent(
                                      dateKey: selectedDate,
                                      event: result,
                                    );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (selectedEvents.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  "NENHUM EVENTO PROGRAMADO PARA ESTE DIA.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Aproveite para estudar no 11º andar! 📚",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        for (final event in selectedEvents)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ArtPopCard(
                              padding: const EdgeInsets.all(24),
                              shadowOffset: const Offset(6, 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: eventCategoryColor(event.category),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      event.category.toUpperCase(),
                                      style: TextStyle(
                                        color: event.category == "Acadêmico"
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    event.title.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    event.description,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.only(top: 12),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Wrap(
                                      spacing: 16,
                                      runSpacing: 8,
                                      children: [
                                        _MetaText(
                                          icon: Icons.location_on_outlined,
                                          label: event.location,
                                        ),
                                        _MetaText(
                                          icon: Icons.schedule,
                                          label: event.time,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key, required this.selectedDate});

  final String selectedDate;

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  String category = "Social";

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    timeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ArtPopCard(
        shadowOffset: const Offset(20, 20),
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "CADASTRAR NOVO EVENTO",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "DATA: ${widget.selectedDate.split("-").reversed.join("/")}",
                style: const TextStyle(
                  color: GlossipColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 24),
              _LabeledTextField(
                label: "Título do Evento",
                controller: titleController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DropdownGroup(
                      label: "Categoria",
                      value: category,
                      items: const [
                        "Social",
                        "Acadêmico",
                        "Esporte",
                        "Cultura",
                      ],
                      onChanged: (value) => setState(() => category = value),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _LabeledTextField(
                      label: "Horário",
                      controller: timeController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _LabeledTextField(
                label: "Localização",
                controller: locationController,
              ),
              const SizedBox(height: 16),
              _LabeledTextField(
                label: "Descrição",
                controller: descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              GlossipButton(
                label: "Salvar Evento",
                onPressed: () {
                  if (titleController.text.trim().isEmpty) {
                    return;
                  }
                  Navigator.of(context).pop(
                    UniversityEvent(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.trim(),
                      category: category,
                      location: locationController.text.trim(),
                      time: timeController.text.trim(),
                      description: descriptionController.text.trim(),
                    ),
                  );
                },
                expanded: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GossipCard extends ConsumerStatefulWidget {
  const GossipCard({super.key, required this.post});

  final GossipPost post;

  @override
  ConsumerState<GossipCard> createState() => _GossipCardState();
}

class _GossipCardState extends ConsumerState<GossipCard> {
  bool showComments = false;
  bool isEditing = false;
  late final TextEditingController editController = TextEditingController(
    text: widget.post.content,
  );
  final commentController = TextEditingController();

  @override
  void dispose() {
    editController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(appControllerProvider);
    final post = controller.gossips.firstWhere(
      (item) => item.id == widget.post.id,
      orElse: () => widget.post,
    );
    final isAuthor = post.authorId == controller.currentUser?.id;
    final timeLabel = DateFormat.Hm("pt_BR").format(post.timestamp);

    return ArtPopCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: GlossipColors.primary,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Text(
                        post.category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (post.target != null) ...[
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            const TextSpan(text: "Para: "),
                            TextSpan(
                              text: post.target!,
                              style: const TextStyle(
                                color: GlossipColors.secondary,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (isAuthor)
                    _IconChip(
                      label: post.isFollowing ? "🔔" : "🔕",
                      onTap: () => ref
                          .read(appControllerProvider)
                          .toggleFollowGossip(post.id),
                    ),
                  if (isAuthor)
                    _IconChip(
                      label: "✏️",
                      onTap: () => setState(() => isEditing = !isEditing),
                    ),
                  if (isAuthor)
                    _IconChip(
                      label: "🗑️",
                      onTap: () async {
                        final confirmed =
                            await showDialog<bool>(
                              context: context,
                              builder: (context) => _ConfirmDialog(
                                title:
                                    "Tem certeza que deseja excluir esta fofoca?",
                                confirmLabel: "Excluir",
                              ),
                            ) ??
                            false;
                        if (confirmed) {
                          ref.read(appControllerProvider).deleteGossip(post.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Fofoca excluída (Simulação Mock)!",
                                ),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  Text(
                    timeLabel,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isEditing) ...[
            GlossipInput(
              child: TextField(
                controller: editController,
                maxLines: 4,
                decoration: const InputDecoration.collapsed(hintText: ""),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            GlossipButton(
              label: "Salvar",
              onPressed: () {
                ref
                    .read(appControllerProvider)
                    .updateGossip(post.id, editController.text.trim());
                setState(() => isEditing = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Conteúdo atualizado (Simulação Mock)!"),
                  ),
                );
              },
            ),
          ] else ...[
            HashtagText(
              post.content,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                height: 1.4,
              ),
            ),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 20),
              Container(
                decoration: borderedBoxDecoration(
                  color: Colors.white,
                  shadowOffset: const Offset(6, 6),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  post.imageUrl!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    height: 200,
                    child: Center(child: Text("Imagem indisponível")),
                  ),
                ),
              ),
            ],
          ],
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              const _ActionChip(label: "👍 Like"),
              const _ActionChip(label: "👎 Dislike"),
              _ActionChip(
                label: "💬 Comentar (${post.comments.length})",
                active: showComments,
                onTap: () => setState(() => showComments = !showComments),
              ),
            ],
          ),
          if (showComments) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: Column(
                children: [
                  for (final comment in post.comments)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: "${comment.author}: ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  TextSpan(text: comment.text),
                                ],
                              ),
                            ),
                          ),
                          if (comment.authorId != null &&
                              comment.authorId == controller.currentUser?.id)
                            IconButton(
                              onPressed: () async {
                                final confirmed =
                                    await showDialog<bool>(
                                      context: context,
                                      builder: (context) =>
                                          const _ConfirmDialog(
                                            title: "Excluir seu comentário?",
                                            confirmLabel: "Excluir",
                                          ),
                                    ) ??
                                    false;
                                if (confirmed) {
                                  ref
                                      .read(appControllerProvider)
                                      .deleteComment(post.id, comment.id);
                                }
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GlossipInput(
                          child: TextField(
                            controller: commentController,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration.collapsed(
                              hintText: "Escreva um comentário...",
                            ),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GlossipButton(
                        label: "Enviar",
                        background: Colors.black,
                        foreground: Colors.white,
                        onPressed: commentController.text.trim().isEmpty
                            ? null
                            : () {
                                ref
                                    .read(appControllerProvider)
                                    .addComment(
                                      post.id,
                                      commentController.text.trim(),
                                    );
                                commentController.clear();
                                setState(() {});
                              },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ProfileGridCard extends ConsumerWidget {
  const ProfileGridCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(appControllerProvider);
    final isOwnProfile = profile.username == controller.currentUser?.username;
    final liked = controller.likedProfiles.contains(profile.username);

    return ArtPopCard(
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
          if (profile.firstName != null || profile.lastName != null)
            Text(
              "@${profile.username}",
              style: const TextStyle(
                color: GlossipColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _Tag(text: profile.course ?? "Curso não inf."),
              _Tag(text: profile.gender ?? "Não informado"),
              _Tag(text: profile.orientation ?? "Não informado"),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              if (profile.instagram != null)
                Expanded(
                  child: _SquareActionButton(
                    icon: Icons.camera_alt_outlined,
                    onTap: () => openInstagram(profile.instagram!),
                  ),
                ),
              if (profile.instagram != null) const SizedBox(width: 10),
              if (!isOwnProfile)
                Expanded(
                  child: _SquareActionButton(
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
              onPressed: !controller.isLoggedIn
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Você precisa estar logado para dar like em um perfil!",
                          ),
                        ),
                      );
                    }
                  : () => ref
                        .read(appControllerProvider)
                        .toggleLikedProfile(profile.username),
              expanded: true,
            ),
        ],
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle({
    required this.titleStart,
    required this.titleHighlight,
    required this.subtitle,
    this.gradient2 = false,
  });

  final String titleStart;
  final String titleHighlight;
  final String subtitle;
  final bool gradient2;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        Text.rich(
          TextSpan(
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: width < 600 ? 42 : 62,
              shadows: const [
                Shadow(color: Colors.black, offset: Offset(4, 4)),
              ],
            ),
            children: [
              TextSpan(text: titleStart),
              TextSpan(
                text: titleHighlight,
                style: TextStyle(
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: gradient2
                          ? const [
                              GlossipColors.secondary,
                              GlossipColors.accent,
                            ]
                          : const [
                              GlossipColors.primary,
                              GlossipColors.secondary,
                            ],
                    ).createShader(Rect.fromLTWH(0, 0, 240, 60)),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Transform.rotate(
          angle: 0.02,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: GlossipColors.accent,
              border: Border.all(color: Colors.black, width: 4),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(6, 6)),
              ],
            ),
            child: Text(
              subtitle.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 48,
            shadows: [Shadow(color: Colors.black, offset: Offset(4, 4))],
          ),
        ),
        const SizedBox(height: 8),
        Transform.rotate(
          angle: -0.02,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: GlossipColors.accent,
              border: Border.all(color: Colors.black, width: 4),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(6, 6)),
              ],
            ),
            child: Text(
              subtitle.toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 3),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
          items: [
            for (final item in items)
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

class _DropdownGroup extends StatelessWidget {
  const _DropdownGroup({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        const SizedBox(height: 8),
        _DropdownField(value: value, items: items, onChanged: onChanged),
      ],
    );
  }
}

class _LabeledTextField extends StatelessWidget {
  const _LabeledTextField({
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
        FieldLabel(label),
        const SizedBox(height: 8),
        GlossipInput(
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: const InputDecoration.collapsed(hintText: ""),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassField extends StatelessWidget {
  const _GlassField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration.collapsed(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        ),
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({
    required this.icon,
    this.onTap,
    this.background = Colors.white,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: onTap == null ? background.withValues(alpha: 0.5) : background,
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: onTap == null
              ? null
              : const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}

class _SquareActionButton extends StatelessWidget {
  const _SquareActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: borderedBoxDecoration(
          color: Colors.white,
          shadowOffset: const Offset(3, 3),
          borderWidth: 3,
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, this.active = false, this.onTap});

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.white,
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(3, 3)),
          ],
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  const _IconChip({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Text(label),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.black),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({required this.title, required this.confirmLabel});

  final String title;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(title),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
