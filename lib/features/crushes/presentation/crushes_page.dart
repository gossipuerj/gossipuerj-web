import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "../../../core/theme/app_breakpoints.dart";
import "../../../features/auth/presentation/session/session_cubit.dart";
import "../../../shared/layout/page_container.dart";
import "../../../shared/seed/mock_seed_data.dart";
import "../../../shared/state/mock_app_cubits.dart";
import "../../../shared/widgets/art_pop_card.dart";
import "../../../shared/widgets/buttons.dart";
import "../../../shared/widgets/form_fields.dart";
import "../../../shared/widgets/labels.dart";
import "widgets/profile_grid_card.dart";

class CrushesPage extends StatefulWidget {
  const CrushesPage({super.key});

  @override
  State<CrushesPage> createState() => _CrushesPageState();
}

class _CrushesPageState extends State<CrushesPage> {
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
    final profilesState = context.watch<ProfilesCubit>().state;
    final profilesCubit = context.read<ProfilesCubit>();
    final sessionState = context.watch<SessionCubit>().state;
    final search = searchController.text.toLowerCase();
    final filtered = profilesState.profiles.where((profile) {
      if (sessionState.isAuthenticated && profile.username == sessionState.user?.username) {
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
      final profileGender = profilesCubit.normalizedGender(profile.gender ?? "");
      final profileOrientation = profilesCubit.normalizedOrientation(profile.orientation ?? "");
      final matchesCourse = selectedCourse == "Todos" || profileCourse == selectedCourse;
      final matchesGender = selectedGender == "Todos" || profileGender == selectedGender;
      final matchesOrientation =
          selectedOrientation == "Todos" || profileOrientation == selectedOrientation;
      return matchesSearch && matchesCourse && matchesGender && matchesOrientation;
    }).toList();

    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= AppBreakpoints.desktop
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
          const HeroTitle(
            titleStart: "Galeria de ",
            titleHighlight: "Crushes",
            subtitle: "Encontre outros alunos da UERJ e demonstre seu interesse.",
            gradient2: true,
          ),
          const SizedBox(height: 32),
          if (!sessionState.isAuthenticated)
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: ArtPopCard(
                color: Colors.yellow,
                shadowOffset: const Offset(8, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Você precisa estar logado para dar like nos perfis.",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
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
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
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
                            fontWeight: FontWeight.w800,
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
                    final courseDropdown = DropdownGroup(
                      label: "Curso",
                      value: selectedCourse,
                      items: const ["Todos", ...uerjCourses],
                      onChanged: (value) => setState(() => selectedCourse = value),
                    );
                    final genderDropdown = DropdownGroup(
                      label: "Gênero",
                      value: selectedGender,
                      items: genders,
                      onChanged: (value) => setState(() => selectedGender = value),
                    );
                    final orientationDropdown = DropdownGroup(
                      label: "Orientação",
                      value: selectedOrientation,
                      items: orientations,
                      onChanged: (value) => setState(() => selectedOrientation = value),
                    );
                    if (vertical) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          courseDropdown,
                          const SizedBox(height: 16),
                          genderDropdown,
                          const SizedBox(height: 16),
                          orientationDropdown,
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: courseDropdown),
                        const SizedBox(width: 20),
                        Expanded(child: genderDropdown),
                        const SizedBox(width: 20),
                        Expanded(child: orientationDropdown),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (filtered.isEmpty)
            const ArtPopCard(
              child: Center(
                child: Text(
                  "NENHUM PERFIL CORRESPONDE AOS SEUS FILTROS.",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
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
              itemBuilder: (context, index) => ProfileGridCard(profile: filtered[index]),
            ),
        ],
      ),
    );
  }
}
