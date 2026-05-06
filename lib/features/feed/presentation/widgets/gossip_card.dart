import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

import "../../../../core/theme/glossip_colors.dart";
import "../../../../domain/models/gossip_post.dart";
import "../../../../features/auth/presentation/session/session_cubit.dart";
import "../../../../shared/state/mock_app_cubits.dart";
import "../../../../shared/widgets/glossip_components.dart";
import "../../../../shared/widgets/hashtag_text.dart";

class GossipCard extends StatefulWidget {
  const GossipCard({super.key, required this.post});

  final GossipPost post;

  @override
  State<GossipCard> createState() => _GossipCardState();
}

class _GossipCardState extends State<GossipCard> {
  bool showComments = false;
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedCubit = context.read<FeedCubit>();
    final feedState = context.watch<FeedCubit>().state;
    final sessionState = context.watch<SessionCubit>().state;
    final post = feedState.gossips.firstWhere(
      (item) => item.id == widget.post.id,
      orElse: () => widget.post,
    );
    final isAuthor = post.authorId == sessionState.user?.id;
    final isLiked = feedCubit.isPostLiked(post.id);
    final isCommentsLoading = feedCubit.isCommentsLoading(post.id);
    final timeLabel = DateFormat("dd/MM HH:mm", "pt_BR").format(post.timestamp);

    return GlossipHoverCard(
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
                        feedCubit.displayCategory(post.category).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      post.title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      feedCubit.postAuthorLabel(post),
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.65),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (isAuthor)
                    GlossipMiniChipButton(
                      label: "🗑️",
                      onTap: () async {
                        final feedCubit = context.read<FeedCubit>();
                        final messenger = ScaffoldMessenger.of(context);
                        final confirmed =
                            await showDialog<bool>(
                              context: context,
                              builder: (context) => const GlossipConfirmationDialog(
                                title: "Tem certeza que deseja excluir esta fofoca?",
                                confirmLabel: "Excluir",
                              ),
                            ) ??
                            false;
                        if (!confirmed) {
                          return;
                        }
                        await feedCubit.deleteGossip(post.id);
                        if (context.mounted &&
                            feedCubit.state.message == null) {
                          messenger.showSnackBar(
                            const SnackBar(content: Text("Fofoca excluída!")),
                          );
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
              decoration: glossipBoxDecoration(
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
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              GlossipChipButton(
                label: "${isLiked ? "💔" : "👍"} Like (${post.likesCount})",
                active: isLiked,
                onTap: () => context.read<FeedCubit>().toggleLikeGossip(post.id),
              ),
              GlossipChipButton(
                label: "💬 Comentar",
                active: showComments,
                onTap: () {
                  setState(() => showComments = !showComments);
                  if (showComments && post.comments.isEmpty) {
                    context.read<FeedCubit>().loadComments(post.id);
                  }
                },
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
                  if (isCommentsLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: GlossipSpinnerProgressIndicator(radius: 24),
                    )
                  else ...[
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
                                      text:
                                          "${feedCubit.commentAuthorLabel(comment)}: ",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    TextSpan(text: comment.content),
                                  ],
                                ),
                              ),
                            ),
                            if (comment.authorId != null &&
                                comment.authorId == sessionState.user?.id)
                              IconButton(
                                onPressed: () async {
                                  final feedCubit = context.read<FeedCubit>();
                                  final confirmed =
                                      await showDialog<bool>(
                                        context: context,
                                        builder: (context) =>
                                            const GlossipConfirmationDialog(
                                              title: "Excluir seu comentário?",
                                              confirmLabel: "Excluir",
                                            ),
                                      ) ??
                                      false;
                                  if (confirmed) {
                                    await feedCubit.deleteComment(
                                      post.id,
                                      comment.id,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.delete_outline),
                              ),
                          ],
                        ),
                      ),
                    if (post.comments.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Ainda não há comentários.",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GlossipInput(
                          child: TextField(
                            controller: commentController,
                            maxLength: 250,
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
                            : () async {
                                final feedCubit = context.read<FeedCubit>();
                                await feedCubit.addComment(
                                  post.id,
                                  commentController.text.trim(),
                                );
                                if (!context.mounted) {
                                  return;
                                }
                                if (feedCubit.state.message == null) {
                                  commentController.clear();
                                  setState(() {});
                                }
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
