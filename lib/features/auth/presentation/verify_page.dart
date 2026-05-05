import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "../../../shared/layout/page_container.dart";
import "../../../shared/widgets/art_pop_card.dart";
import "../../../shared/widgets/buttons.dart";
import "auth/auth_cubit.dart";
import "auth/auth_state.dart";
import "session/session_state.dart";
import "session/session_cubit.dart";

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key, required this.token});

  final String? token;

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool hasRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hasRequested) {
      return;
    }
    hasRequested = true;
    final token = widget.token;
    if (token == null || token.isEmpty) {
      return;
    }
    context.read<AuthCubit>().verify(token);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, authState) {
            if (authState.status == AuthStatus.verified &&
                context.read<SessionCubit>().state.status == SessionStatus.authenticated) {
              context.go("/profile");
            }
          },
        ),
        BlocListener<SessionCubit, SessionState>(
          listener: (context, sessionState) {
            if (sessionState.status == SessionStatus.authenticated) {
              context.go("/profile");
            }
          },
        ),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final tokenMissing = widget.token == null || widget.token!.isEmpty;
          return PageContainer(
            maxWidth: 640,
            child: ArtPopCard(
              child: Column(
                children: [
                  Text(
                    tokenMissing
                        ? "LINK INVÁLIDO"
                        : state.status == AuthStatus.failure
                        ? "NÃO FOI POSSÍVEL VALIDAR"
                        : "VALIDANDO SEU ACESSO",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tokenMissing
                        ? "Esse link não contém um token válido."
                        : state.status == AuthStatus.failure
                        ? (state.message ?? "O link expirou ou é inválido.")
                        : "Aguarde enquanto concluímos seu login.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!tokenMissing && state.status == AuthStatus.submitting)
                    const CircularProgressIndicator(),
                  if (tokenMissing || state.status == AuthStatus.failure) ...[
                    GlossipButton(
                      label: "Voltar ao login",
                      onPressed: () => context.go("/login"),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
