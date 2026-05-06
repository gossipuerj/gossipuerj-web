import "package:equatable/equatable.dart";

import "../../../../domain/models/user_profile.dart";

class SessionState extends Equatable {
  const SessionState({required this.status, this.user, this.message});

  const SessionState.initial() : this(status: SessionStatus.initial);

  const SessionState.loading() : this(status: SessionStatus.loading);

  const SessionState.authenticated(UserProfile user)
    : this(status: SessionStatus.authenticated, user: user);

  const SessionState.unauthenticated({String? message})
    : this(status: SessionStatus.unauthenticated, message: message);

  final SessionStatus status;
  final UserProfile? user;
  final String? message;

  bool get isAuthenticated => status == SessionStatus.authenticated;

  @override
  List<Object?> get props => [status, user, message];
}

enum SessionStatus { initial, loading, authenticated, unauthenticated }
