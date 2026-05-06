import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../core/theme/glossip_colors.dart";
import "../../../../shared/state/mock_app_cubits.dart";
import "../../../../shared/widgets/glossip_components.dart";

class FeedComposer extends StatelessWidget {
  const FeedComposer({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.composerCategory,
    required this.onCategoryChanged,
    required this.onChanged,
    this.wrapInCard = true,
    this.onSubmitted,
  });

  final TextEditingController titleController;
  final TextEditingController contentController;
  final String composerCategory;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onChanged;
  final bool wrapInCard;
  final VoidCallback? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final feedState = context.watch<FeedCubit>().state;

    final composer = Column(
      children: [
        GlossipInput(
          child: TextField(
            controller: titleController,
            maxLength: 250,
            onChanged: (_) => onChanged(),
            decoration: const InputDecoration.collapsed(
              hintText: "Título da publicação",
            ),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
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
            onChanged: (_) => onChanged(),
            decoration: const InputDecoration.collapsed(
              hintText: "O que está acontecendo no campus?",
            ),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.only(top: 12),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black, width: 3)),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 8,
            spacing: 12,
            children: [
              GlossipSelectField(
                value: composerCategory,
                items: const ["Fofoca", "Desabafo", "Paquera"],
                onChanged: onCategoryChanged,
              ),
              Text(
                "${contentController.text.length}/280",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
              GlossipButton(
                label: "Publicar Anonimamente",
                emphasizedLabel: true,
                onPressed:
                    contentController.text.trim().isEmpty ||
                        titleController.text.trim().isEmpty ||
                        feedState.isSubmitting
                    ? null
                    : () async {
                        await context.read<FeedCubit>().postGossip(
                          title: titleController.text.trim(),
                          content: contentController.text.trim(),
                          category: composerCategory,
                        );
                        if (!context.mounted) {
                          return;
                        }
                        final nextState = context.read<FeedCubit>().state;
                        if (nextState.message == null) {
                          titleController.clear();
                          contentController.clear();
                          onChanged();
                          onSubmitted?.call();
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
    );

    if (!wrapInCard) {
      return composer;
    }

    return GlossipCard(shadowOffset: const Offset(12, 12), child: composer);
  }
}

class FeedComposerFab extends StatefulWidget {
  const FeedComposerFab({super.key});

  @override
  State<FeedComposerFab> createState() => _FeedComposerFabState();
}

class _FeedComposerFabState extends State<FeedComposerFab> {
  Future<void> _openComposerDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final width = MediaQuery.sizeOf(dialogContext).width;

        return GlossipDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: width < 420 ? 16 : 24,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlossipDialogHeader(
                    title: "NOVA FOFOCA",
                    eyebrow: "ANONIMO",
                    trailing: GlossipIconButton(
                      icon: Icons.close,
                      onTap: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _FeedComposerDialogContent(
                    onSubmitted: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _openComposerDialog,
      backgroundColor: GlossipColors.secondary,
      foregroundColor: Colors.black,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: const BorderSide(color: Colors.black, width: 3),
      ),
      icon: const Icon(Icons.edit_outlined),
      label: const Text(
        "POSTAR",
        style: TextStyle(fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _FeedComposerDialogContent extends StatefulWidget {
  const _FeedComposerDialogContent({required this.onSubmitted});

  final VoidCallback onSubmitted;

  @override
  State<_FeedComposerDialogContent> createState() =>
      _FeedComposerDialogContentState();
}

class _FeedComposerDialogContentState extends State<_FeedComposerDialogContent> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String composerCategory = "Fofoca";

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FeedComposer(
      titleController: titleController,
      contentController: contentController,
      composerCategory: composerCategory,
      onCategoryChanged: (value) => setState(() => composerCategory = value),
      onChanged: () => setState(() {}),
      wrapInCard: false,
      onSubmitted: widget.onSubmitted,
    );
  }
}
