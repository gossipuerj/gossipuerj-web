import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";

import "../../../core/theme/glossip_colors.dart";
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
            maxWidth: 450,
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ArtPopCard(
                color: const Color(0xFFFFF7FB),
                shadowOffset: const Offset(14, 14),
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "GLOSSIP",
                        style: GoogleFonts.outfit(
                          fontSize: 29,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                        children: const [
                          TextSpan(
                            text: "UERJ",
                            style: TextStyle(color: GlossipColors.primary),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      tokenMissing
                          ? "Link inválido"
                          : state.status == AuthStatus.failure
                          ? "Não foi possível validar"
                          : "Validando seu acesso",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tokenMissing
                          ? "Esse link não contém um token válido."
                          : state.status == AuthStatus.failure
                          ? (state.message ?? "O link expirou ou é inválido.")
                          : "Aguarde enquanto concluímos seu login.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (!tokenMissing && state.status == AuthStatus.submitting)
                      const Center(child: CircularProgressIndicator()),
                    if (tokenMissing || state.status == AuthStatus.failure)
                      _VerifyButton(
                        label: "Voltar ao login",
                        onPressed: () => context.go("/login"),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _VerifyButton extends StatelessWidget {
  const _VerifyButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: GlossipButton(
        label: label,
        onPressed: onPressed,
        expanded: true,
        emphasizedLabel: true,
        foreground: Colors.white,
        background: GlossipColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }
}
