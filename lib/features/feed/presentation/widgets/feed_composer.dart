import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../shared/state/mock_app_cubits.dart";
import "../../../../shared/widgets/glossip_components.dart";

class FeedComposer extends StatelessWidget {
  const FeedComposer({
    super.key,
    required this.targetController,
    required this.contentController,
    required this.composerCategory,
    required this.onCategoryChanged,
    required this.onChanged,
  });

  final TextEditingController targetController;
  final TextEditingController contentController;
  final String composerCategory;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return GlossipCard(
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
                  onPressed: contentController.text.trim().isEmpty
                      ? null
                      : () async {
                          await context.read<FeedCubit>().postGossip(
                            target: targetController.text.trim(),
                            content: contentController.text.trim(),
                            category: composerCategory,
                          );
                          targetController.clear();
                          contentController.clear();
                          onChanged();
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
    );
  }
}
