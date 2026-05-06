import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:google_fonts/google_fonts.dart";

import "../../../core/theme/glossip_colors.dart";
import "../../../shared/layout/page_container.dart";
import "../../../shared/widgets/glossip_components.dart";
import "auth/auth_cubit.dart";
import "auth/auth_state.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  String? loginEmailError;
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final personalEmailController = TextEditingController();

  static final _institutionalEmailPattern = RegExp(
    r"^[^@\s]+@graduacao\.uerj\.br$",
    caseSensitive: false,
  );

  bool _validateLoginEmail() {
    final email = emailController.text.trim();
    final isValid = _institutionalEmailPattern.hasMatch(email);
    setState(() {
      loginEmailError = isValid
          ? null
          : "Use apenas seu email institucional @graduacao.uerj.br";
    });
    return isValid;
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    personalEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure && state.statusCode == 500) {
          showDialog<void>(
            context: context,
            barrierColor: Colors.black.withValues(alpha: 0.35),
            builder: (context) => GlossipDialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const GlossipDialogHeader(
                    title: "Algo deu errado no servidor.",
                    eyebrow: "Erro interno",
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "O servidor encontrou um erro interno ao processar sua solicitação. Tente novamente em instantes.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: Colors.black.withValues(alpha: 0.65),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GlossipButton(
                    label: "Fechar",
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<AuthCubit>().clearFeedback();
                    },
                    expanded: true,
                    emphasizedLabel: true,
                    foreground: Colors.white,
                    background: GlossipColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
          return;
        }

        if (state.status == AuthStatus.failure ||
            state.status == AuthStatus.validationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? "Ocorreu um erro.")),
          );
        }
        if (state.status == AuthStatus.magicLinkSent ||
            state.status == AuthStatus.registrationSubmitted) {
          setState(() => loginEmailError = null);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Enviamos um link para ${state.email}. Abra seu email para continuar.",
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final cardTextTheme = GoogleFonts.outfitTextTheme(
          Theme.of(context).textTheme,
        );
        return PageContainer(
          maxWidth: 450,
          padding: const EdgeInsets.all(24),
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.94, end: 1),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              builder: (context, scale, child) {
                return Opacity(
                  opacity: scale.clamp(0, 1),
                  child: Transform.scale(scale: scale, child: child),
                );
              },
              child: GlossipCard(
                color: const Color(0xFFFFF7FB),
                shadowOffset: const Offset(14, 14),
                padding: const EdgeInsets.all(32),
                child: DefaultTextStyle.merge(
                  style: cardTextTheme.bodyMedium,
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
                      const SizedBox(height: 24),
                      Text(
                        isLogin ? "Bem-vindo de volta" : "Criar sua conta",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isLogin
                            ? "Acesse com seu email institucional para receber um link de entrada."
                            : "Use seu email institucional para criar sua conta.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withValues(alpha: 0.65),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isLogin) ...[
                            _FieldBlock(
                              label: "Nome",
                              child: GlossipGlassField(
                                controller: firstNameController,
                                hint: "Seu nome",
                                darkText: true,
                              ),
                              errorText: state.fieldErrors["firstName"],
                            ),
                            const SizedBox(height: 24),
                            _FieldBlock(
                              label: "Sobrenome",
                              child: GlossipGlassField(
                                controller: lastNameController,
                                hint: "Seu sobrenome",
                                darkText: true,
                              ),
                              errorText: state.fieldErrors["lastName"],
                            ),
                            const SizedBox(height: 24),
                          ],
                          _FieldBlock(
                            label: isLogin ? "Email" : "Email Institucional",
                            child: GlossipGlassField(
                              controller: emailController,
                              hint: "voce@graduacao.uerj.br",
                              onChanged: isLogin
                                  ? (_) {
                                      if (loginEmailError != null) {
                                        _validateLoginEmail();
                                      }
                                    }
                                  : null,
                              darkText: true,
                            ),
                            errorText: isLogin
                                ? (loginEmailError ??
                                      state.fieldErrors["email"])
                                : state.fieldErrors["email"],
                          ),
                          if (!isLogin) ...[
                            const SizedBox(height: 24),
                            _FieldBlock(
                              label: "Email Pessoal (Opcional)",
                              child: GlossipGlassField(
                                controller: personalEmailController,
                                hint: "voce@gmail.com",
                                darkText: true,
                              ),
                              errorText: state.fieldErrors["personalEmail"],
                            ),
                          ],
                          const SizedBox(height: 8),
                          if (state.message != null &&
                              state.statusCode != 500 &&
                              (state.status == AuthStatus.failure ||
                                  state.status == AuthStatus.validationFailure))
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                state.message!,
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFFFF4444),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          const SizedBox(height: 32),
                          _SubmitButton(
                            label: state.status == AuthStatus.submitting
                                ? "Carregando..."
                                : isLogin
                                ? "Entrar"
                                : "Registrar",
                            onPressed: state.status == AuthStatus.submitting
                                ? null
                                : () {
                                    if (isLogin) {
                                      if (!_validateLoginEmail()) {
                                        return;
                                      }
                                      context.read<AuthCubit>().login(
                                        emailController.text.trim(),
                                      );
                                      return;
                                    }
                                    context.read<AuthCubit>().register(
                                      firstName: firstNameController.text
                                          .trim(),
                                      lastName: lastNameController.text.trim(),
                                      email: emailController.text.trim(),
                                      personalEmail:
                                          personalEmailController.text
                                              .trim()
                                              .isEmpty
                                          ? null
                                          : personalEmailController.text.trim(),
                                    );
                                  },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            isLogin ? "Não tem conta?" : "Já tem conta?",
                            style: GoogleFonts.outfit(
                              color: Colors.black.withValues(alpha: 0.65),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              context.read<AuthCubit>().clearFeedback();
                              setState(() => isLogin = !isLogin);
                            },
                            child: Text(
                              isLogin ? "Crie agora" : "Faça login",
                              style: GoogleFonts.outfit(
                                color: GlossipColors.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => context.go("/"),
                        child: Text(
                          "Voltar ao Feed",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            color: Colors.black.withValues(alpha: 0.45),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({required this.label, required this.child, this.errorText});

  final String label;
  final Widget child;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        child,
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFFF4444),
            ),
          ),
        ],
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

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
