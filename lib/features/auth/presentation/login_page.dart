import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../core/theme/glossip_colors.dart";
import "../../../shared/layout/page_container.dart";
import "../../../shared/providers/app_providers.dart";
import "../../../shared/widgets/form_fields.dart";

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool isLogin = true;
  String error = "";
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider);
    return PageContainer(
      maxWidth: 450,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(48),
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
                isLogin ? "Bem-vindo de volta" : "Criar sua conta",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isLogin
                    ? "Acesse para demonstrar interesse nos crushes."
                    : "Use seu @ do Instagram como usuário.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    " @ DO INSTAGRAM",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  GlassField(
                    controller: usernameController,
                    hint: "@seu_insta",
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "SENHA",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  GlassField(
                    controller: passwordController,
                    hint: "••••••••",
                    obscureText: true,
                  ),
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      error,
                      style: const TextStyle(color: Color(0xFFFF4444)),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: session.isAuthenticating
                          ? null
                          : () async {
                              setState(() => error = "");
                              final username = usernameController.text.trim();
                              final password = passwordController.text.trim();
                              final ok = isLogin
                                  ? await ref
                                        .read(sessionControllerProvider)
                                        .login(
                                          username: username,
                                          password: password,
                                        )
                                  : await ref
                                        .read(sessionControllerProvider)
                                        .register(
                                          username: username,
                                          password: password,
                                        );
                              if (!context.mounted) {
                                return;
                              }
                              if (ok && isLogin) {
                                ref
                                    .read(profilesControllerProvider)
                                    .syncCurrentUserProfile(
                                      ref
                                          .read(sessionControllerProvider)
                                          .currentUser!,
                                    );
                                context.go("/crushes");
                              } else if (ok) {
                                setState(() => isLogin = true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Conta criada! Agora faça o login.",
                                    ),
                                  ),
                                );
                              } else {
                                setState(() => error = "Ocorreu um erro");
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              GlossipColors.primary,
                              GlossipColors.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          session.isAuthenticating
                              ? "Carregando..."
                              : (isLogin ? "Entrar" : "Registrar"),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    isLogin ? "Não tem conta? " : "Já tem conta? ",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin ? "Crie agora" : "Faça login",
                      style: const TextStyle(
                        color: GlossipColors.secondary,
                        fontWeight: FontWeight.w800,
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
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
