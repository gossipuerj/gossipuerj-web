import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";

import "package:flutter_app/domain/models/university_event.dart";
import "package:flutter_app/shared/providers/app_providers.dart";

void main() {
  group("sessionController", () {
    test("login normalizes username and marks user as logged in", () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final session = container.read(sessionControllerProvider);
      final ok = await session.login(username: "@novo_user", password: "1234");

      expect(ok, isTrue);
      expect(session.isLoggedIn, isTrue);
      expect(session.currentUser?.username, "novo_user");
      expect(session.currentUser?.instagram, "novo_user");
    });
  });

  group("feedController", () {
    test("post and comment use the current logged user", () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container
          .read(sessionControllerProvider)
          .login(username: "@aluna", password: "1234");

      final feed = container.read(feedControllerProvider);
      await feed.postGossip(
        target: "@curso",
        content: "Novo post",
        category: "Fofoca",
      );

      final created = feed.gossips.first;
      expect(created.authorId, "user-123");
      expect(created.content, "Novo post");

      feed.addComment(created.id, "Comentário");
      expect(feed.gossips.first.comments.last.authorId, "user-123");
    });
  });

  group("profilesController", () {
    test("updateProfile syncs gallery and session state", () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final session = container.read(sessionControllerProvider);
      final profiles = container.read(profilesControllerProvider);
      final updated = session.currentUser!.copyWith(bio: "Nova bio");

      await profiles.updateProfile(updated);

      expect(
        container.read(sessionControllerProvider).currentUser?.bio,
        "Nova bio",
      );
      expect(
        container
            .read(profilesControllerProvider)
            .profiles
            .firstWhere((item) => item.id == updated.id)
            .bio,
        "Nova bio",
      );
    });
  });

  group("messagesController", () {
    test("openOrCreateConversation and sendMessage update the thread", () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(messagesControllerProvider);
      final conversation = controller.openOrCreateConversation("teste_chat");
      controller.sendMessage(conversationId: conversation.id, text: "Oi");

      expect(controller.chatHistory[conversation.id]?.last.text, "Oi");
      expect(controller.conversations.first.id, conversation.id);
    });
  });

  group("eventsController", () {
    test("addEvent appends event to selected date", () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(eventsControllerProvider);
      final before = controller.events["2026-04-10"]!.length;
      controller.addEvent(
        dateKey: "2026-04-10",
        event: const UniversityEvent(
          id: "x",
          title: "Novo",
          category: "Social",
          location: "Campus",
          time: "20:00",
          description: "Teste",
        ),
      );

      expect(controller.events["2026-04-10"]!.length, before + 1);
    });
  });
}
