import "dart:typed_data";

class UserProfile {
  const UserProfile({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    this.instagram,
    this.avatarUrl,
    this.avatarBytes,
    this.gender,
    this.orientation,
    this.course,
    this.bio,
    this.showInGallery = true,
  });

  final String id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? instagram;
  final String? avatarUrl;
  final Uint8List? avatarBytes;
  final String? gender;
  final String? orientation;
  final String? course;
  final String? bio;
  final bool showInGallery;

  String get displayName {
    final composed = "${firstName ?? ""} ${lastName ?? ""}".trim();
    return composed.isEmpty ? "@$username" : composed;
  }

  UserProfile copyWith({
    String? id,
    String? username,
    String? firstName,
    String? lastName,
    String? instagram,
    String? avatarUrl,
    Uint8List? avatarBytes,
    String? gender,
    String? orientation,
    String? course,
    String? bio,
    bool? showInGallery,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      instagram: instagram ?? this.instagram,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarBytes: avatarBytes ?? this.avatarBytes,
      gender: gender ?? this.gender,
      orientation: orientation ?? this.orientation,
      course: course ?? this.course,
      bio: bio ?? this.bio,
      showInGallery: showInGallery ?? this.showInGallery,
    );
  }
}

class GossipComment {
  const GossipComment({
    required this.id,
    required this.text,
    required this.author,
    this.authorId,
  });

  final String id;
  final String text;
  final String author;
  final String? authorId;
}

class GossipPost {
  const GossipPost({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.category,
    required this.authorId,
    this.target,
    this.imageUrl,
    this.isFollowing = false,
    this.comments = const [],
  });

  final String id;
  final String content;
  final DateTime timestamp;
  final String category;
  final String authorId;
  final String? target;
  final String? imageUrl;
  final bool isFollowing;
  final List<GossipComment> comments;

  GossipPost copyWith({
    String? content,
    DateTime? timestamp,
    String? category,
    String? target,
    String? imageUrl,
    bool? isFollowing,
    List<GossipComment>? comments,
  }) {
    return GossipPost(
      id: id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      authorId: authorId,
      target: target ?? this.target,
      imageUrl: imageUrl ?? this.imageUrl,
      isFollowing: isFollowing ?? this.isFollowing,
      comments: comments ?? this.comments,
    );
  }
}

class UniversityEvent {
  const UniversityEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.time,
    required this.description,
  });

  final String id;
  final String title;
  final String category;
  final String location;
  final String time;
  final String description;
}

class ConversationSummary {
  const ConversationSummary({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.timeLabel,
    this.unread = false,
  });

  final int id;
  final String user;
  final String lastMessage;
  final String timeLabel;
  final bool unread;

  ConversationSummary copyWith({
    String? lastMessage,
    String? timeLabel,
    bool? unread,
  }) {
    return ConversationSummary(
      id: id,
      user: user,
      lastMessage: lastMessage ?? this.lastMessage,
      timeLabel: timeLabel ?? this.timeLabel,
      unread: unread ?? this.unread,
    );
  }
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.timeLabel,
    required this.sender,
  });

  final int id;
  final String text;
  final String timeLabel;
  final ChatSender sender;
}

enum ChatSender { me, them }
