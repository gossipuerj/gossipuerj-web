import "package:flutter_test/flutter_test.dart";

import "package:flutter_app/features/auth/presentation/session/session_cubit.dart";
import "package:flutter_app/shared/state/mock_app_cubits.dart";

import "support/fakes.dart";

void main() {
  group("sessionCubit", () {
    test("starts unauthenticated when there is no token", () async {
      final tokenStore = InMemoryTokenStore();
      final cubit = SessionCubit(FakeAuthRepository(), tokenStore);

      await cubit.start();

      expect(cubit.state.isAuthenticated, isFalse);
    });
  });

  group("feedCubit", () {
    test("post and comment use the current logged user", () async {
      final authRepository = FakeAuthRepository();
      final tokenStore = InMemoryTokenStore(initialToken: "abc");
      final sessionCubit = SessionCubit(authRepository, tokenStore);
      await sessionCubit.start();
      final feedCubit = FeedCubit(sessionCubit);

      await feedCubit.postGossip(target: "@curso", content: "Novo post", category: "Fofoca");

      final created = feedCubit.state.gossips.first;
      expect(created.authorId, authRepository.user.id);
      feedCubit.addComment(created.id, "Comentário");
      expect(feedCubit.state.gossips.first.comments.last.authorId, authRepository.user.id);
    });
  });

  group("messagesCubit", () {
    test("openOrCreateConversation and sendMessage update the thread", () {
      final cubit = MessagesCubit();
      final conversation = cubit.openOrCreateConversation("teste_chat");
      cubit.sendMessage(conversationId: conversation.id, text: "Oi");

      expect(cubit.state.chatHistory[conversation.id]?.last.text, "Oi");
      expect(cubit.state.conversations.first.id, conversation.id);
    });
  });

  group("eventsCubit", () {
    test("addEvent appends event to selected date", () {
      final cubit = EventsCubit();
      final before = cubit.state.events["2026-04-10"]!.length;
      cubit.addEvent(dateKey: "2026-04-10", event: fakeEvent());
      expect(cubit.state.events["2026-04-10"]!.length, before + 1);
    });
  });
}
