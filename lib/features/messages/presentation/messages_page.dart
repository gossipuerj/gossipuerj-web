import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../domain/models/chat_message.dart";
import "../../../domain/models/conversation_summary.dart";
import "../../../shared/layout/page_container.dart";
import "../../../shared/providers/app_providers.dart";
import "../../../shared/widgets/art_pop_card.dart";
import "../../../shared/widgets/avatar.dart";
import "../../../shared/widgets/buttons.dart";
import "../../../shared/widgets/form_fields.dart";
import "../../../shared/widgets/labels.dart";

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
        .read(messagesControllerProvider)
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
    final controller = ref.watch(messagesControllerProvider);
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
                const PageHeader(
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
                            ? Colors.pinkAccent
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
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    conversation.lastMessage,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
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
                                  color: Colors.pinkAccent,
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
                      color: Colors.yellow,
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 4),
                      ),
                    ),
                    child: Row(
                      children: [
                        SquareIconButton(
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
                                  fontWeight: FontWeight.w800,
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
                                color: mine ? Colors.pinkAccent : Colors.white,
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
                                      fontWeight: FontWeight.w800,
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
                                        fontWeight: FontWeight.w900,
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
                    padding: EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      20 + MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.black, width: 4),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SquareIconButton(
                          icon: Icons.emoji_emotions_outlined,
                        ),
                        const SizedBox(width: 8),
                        const SquareIconButton(icon: Icons.attach_file),
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
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SquareIconButton(
                          icon: Icons.send,
                          background: Colors.cyanAccent,
                          onTap: newMessageController.text.trim().isEmpty
                              ? null
                              : () {
                                  ref
                                      .read(messagesControllerProvider)
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
