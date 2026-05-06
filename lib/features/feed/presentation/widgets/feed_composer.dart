import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

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
  });

  final TextEditingController titleController;
  final TextEditingController contentController;
  final String composerCategory;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final feedState = context.watch<FeedCubit>().state;

    return GlossipCard(
      shadowOffset: const Offset(12, 12),
      child: Column(
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
    );
  }
}
