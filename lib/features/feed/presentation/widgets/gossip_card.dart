import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

import "../../../../core/theme/glossip_colors.dart";
import "../../../../domain/models/gossip_post.dart";
import "../../../../features/auth/presentation/session/session_cubit.dart";
import "../../../../shared/state/mock_app_cubits.dart";
import "../../../../shared/widgets/art_pop_card.dart";
import "../../../../shared/widgets/buttons.dart";
import "../../../../shared/widgets/confirmation_dialog.dart";
import "../../../../shared/widgets/form_fields.dart";
import "../../../../shared/widgets/hashtag_text.dart";

class GossipCard extends StatefulWidget {
  const GossipCard({super.key, required this.post});

  final GossipPost post;

  @override
  State<GossipCard> createState() => _GossipCardState();
}

class _GossipCardState extends State<GossipCard> {
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
    final feedState = context.watch<FeedCubit>().state;
    final sessionState = context.watch<SessionCubit>().state;
    final post = feedState.gossips.firstWhere(
      (item) => item.id == widget.post.id,
      orElse: () => widget.post,
    );
    final isAuthor = post.authorId == sessionState.user?.id;
    final timeLabel = DateFormat.Hm("pt_BR").format(post.timestamp);

    return HoverArtPopCard(
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
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          const Text(
                            "Para:",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6FAFF),
                              border: Border.all(
                                color: GlossipColors.black,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              post.target!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
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
                    IconChipButton(
                      label: post.isFollowing ? "🔔" : "🔕",
                      onTap: () => context.read<FeedCubit>().toggleFollowGossip(post.id),
                    ),
                  if (isAuthor)
                    IconChipButton(
                      label: "✏️",
                      onTap: () => setState(() => isEditing = !isEditing),
                    ),
                  if (isAuthor)
                    IconChipButton(
                      label: "🗑️",
                      onTap: () async {
                        final confirmed =
                            await showDialog<bool>(
                              context: context,
                              builder: (context) => const ConfirmationDialog(
                                title:
                                    "Tem certeza que deseja excluir esta fofoca?",
                                confirmLabel: "Excluir",
                              ),
                            ) ??
                            false;
                        if (confirmed) {
                          context.read<FeedCubit>().deleteGossip(post.id);
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
                      fontWeight: FontWeight.w700,
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
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            GlossipButton(
              label: "Salvar",
              onPressed: () {
                context.read<FeedCubit>().updateGossip(post.id, editController.text.trim());
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
                fontWeight: FontWeight.w900,
                fontSize: 20,
                height: 1.4,
                letterSpacing: -0.2,
                shadows: [
                  Shadow(
                    color: Colors.black12,
                    offset: Offset(0.6, 0),
                    blurRadius: 0,
                  ),
                ],
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
              const ActionChipButton(label: "👍 Like"),
              const ActionChipButton(label: "👎 Dislike"),
              ActionChipButton(
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
                              comment.authorId == sessionState.user?.id)
                            IconButton(
                              onPressed: () async {
                                final confirmed =
                                    await showDialog<bool>(
                                      context: context,
                                      builder: (context) =>
                                          const ConfirmationDialog(
                                            title: "Excluir seu comentário?",
                                            confirmLabel: "Excluir",
                                          ),
                                    ) ??
                                    false;
                                if (confirmed) {
                                  context.read<FeedCubit>().deleteComment(post.id, comment.id);
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
                              fontWeight: FontWeight.w700,
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
                                context.read<FeedCubit>().addComment(
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
