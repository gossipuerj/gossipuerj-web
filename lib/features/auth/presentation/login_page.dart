import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "../../../core/theme/glossip_colors.dart";
import "../../../shared/layout/page_container.dart";
import "../../../shared/widgets/form_fields.dart";
import "auth/auth_cubit.dart";
import "auth/auth_state.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final personalEmailController = TextEditingController();

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
        if (state.status == AuthStatus.failure ||
            state.status == AuthStatus.validationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? "Ocorreu um erro.")),
          );
        }
        if (state.status == AuthStatus.magicLinkSent ||
            state.status == AuthStatus.registrationSubmitted) {
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
        return PageContainer(
          maxWidth: 520,
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "GLOSSIP",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
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
                    isLogin ? "Entrar com Magic Link" : "Criar sua conta",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isLogin
                        ? "Use seu email institucional ou pessoal vinculado."
                        : "Seu email institucional deve terminar com @graduacao.uerj.br.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 32),
                  if (!isLogin) ...[
                    _FieldBlock(
                      label: "Nome",
                      child: GlassField(
                        controller: firstNameController,
                        hint: "Seu nome",
                      ),
                      errorText: state.fieldErrors["firstName"],
                    ),
                    const SizedBox(height: 20),
                    _FieldBlock(
                      label: "Sobrenome",
                      child: GlassField(
                        controller: lastNameController,
                        hint: "Seu sobrenome",
                      ),
                      errorText: state.fieldErrors["lastName"],
                    ),
                    const SizedBox(height: 20),
                  ],
                  _FieldBlock(
                    label: isLogin ? "Email" : "Email Institucional",
                    child: GlassField(
                      controller: emailController,
                      hint: "voce@graduacao.uerj.br",
                    ),
                    errorText: state.fieldErrors["email"],
                  ),
                  if (!isLogin) ...[
                    const SizedBox(height: 20),
                    _FieldBlock(
                      label: "Email Pessoal (Opcional)",
                      child: GlassField(
                        controller: personalEmailController,
                        hint: "voce@gmail.com",
                      ),
                      errorText: state.fieldErrors["personalEmail"],
                    ),
                  ],
                  const SizedBox(height: 24),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: state.status == AuthStatus.submitting
                          ? null
                          : () {
                              if (isLogin) {
                                context.read<AuthCubit>().login(
                                  emailController.text.trim(),
                                );
                                return;
                              }
                              context.read<AuthCubit>().register(
                                firstName: firstNameController.text.trim(),
                                lastName: lastNameController.text.trim(),
                                email: emailController.text.trim(),
                                personalEmail: personalEmailController.text.trim().isEmpty
                                    ? null
                                    : personalEmailController.text.trim(),
                              );
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [GlossipColors.primary, GlossipColors.secondary],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          state.status == AuthStatus.submitting
                              ? "Carregando..."
                              : isLogin
                              ? "Enviar link de acesso"
                              : "Criar conta",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        isLogin ? "Não tem conta? " : "Já tem conta? ",
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<AuthCubit>().clearFeedback();
                          setState(() => isLogin = !isLogin);
                        },
                        child: Text(
                          isLogin ? "Cadastre-se" : "Entrar",
                          style: const TextStyle(
                            color: GlossipColors.secondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => context.go("/"),
                    child: Text(
                      "Voltar ao Feed",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({
    required this.label,
    required this.child,
    this.errorText,
  });

  final String label;
  final Widget child;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        child,
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(errorText!, style: const TextStyle(color: Color(0xFFFF7777))),
        ],
      ],
    );
  }
}
