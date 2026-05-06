import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../core/theme/app_breakpoints.dart";
import "../../../shared/layout/page_container.dart";
import "../../../shared/state/mock_app_cubits.dart";
import "../../../shared/widgets/glossip_components.dart";
import "../../../shared/widgets/gretchen_blob.dart";
import "widgets/feed_composer.dart";
import "widgets/feed_filter_bar.dart";
import "widgets/feed_hero.dart";
import "widgets/gossip_card.dart";

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  String selectedCategory = "Todos";
  String composerCategory = "Fofoca";

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedCubit = context.read<FeedCubit>();

    return BlocListener<FeedCubit, FeedState>(
      listenWhen: (previous, current) => previous.message != current.message,
      listener: (context, state) {
        if (state.message == null) {
          return;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.message!)));
        context.read<FeedCubit>().clearFeedback();
      },
      child: Builder(
        builder: (context) {
          final feedState = context.watch<FeedCubit>().state;
          final width = MediaQuery.sizeOf(context).width;
          final isCompact = width < AppBreakpoints.tablet;
          final categories = const ["Todos", "Fofoca", "Desabafo", "Paquera"];
          final filtered = selectedCategory == "Todos"
              ? feedState.gossips
              : feedState.gossips
                    .where(
                      (item) =>
                          feedCubit.displayCategory(item.category) ==
                          selectedCategory,
                    )
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
                    if (isCompact)
                      const FeedHeroText(isCompact: true)
                    else
                      const Expanded(child: FeedHeroText(isCompact: false)),
                    const SizedBox(height: 32, width: 32),
                    const GretchenBlob(),
                  ],
                ),
                const SizedBox(height: 40),
                if (!isCompact) ...[
                  FeedComposer(
                    titleController: titleController,
                    contentController: contentController,
                    composerCategory: composerCategory,
                    onCategoryChanged: (value) =>
                        setState(() => composerCategory = value),
                    onChanged: () => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                ],
                FeedFilterBar(
                  width: width,
                  categories: categories,
                  selectedCategory: selectedCategory,
                  onCategorySelected: (value) {
                    setState(() => selectedCategory = value);
                    feedCubit.loadPosts(category: value);
                  },
                ),
                const SizedBox(height: 32),
                if (feedState.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: GlossipSpinnerProgressIndicator(radius: 28),
                    ),
                  )
                else
                  Column(
                    children: [
                      if (filtered.isEmpty)
                        const GlossipCard(
                          child: Center(
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
                      if (feedState.isLoadingMore)
                        const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 24),
                          child: Center(
                            child: GlossipSpinnerProgressIndicator(radius: 24),
                          ),
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
