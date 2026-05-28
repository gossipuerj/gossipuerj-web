# Glossip — Web

Aplicação web em Flutter para a comunidade universitária (gossipuerj).

## Visão geral

Glossip é um projeto Flutter voltado para web que provê feed, mensagens, eventos e perfis de usuários. O projeto usa dependência por injeção centralizada, cubits para estado local e integra com uma API backend via `Dio`.

## Recursos principais

- Feed público com postagens e comentários
- Sistema de autenticação por magic-link
- Páginas de eventos e listagem de crushes
- Mensagens privadas entre usuários
- Estrutura modular com separação de `features` e `shared`

## Arquitetura e pontos importantes

- Ponto de entrada: [lib/main.dart](lib/main.dart)
- Bootstrapping e inicialização: [lib/app/bootstrap.dart](lib/app/bootstrap.dart)
- Registro de dependências: [lib/app/di/service_locator.dart](lib/app/di/service_locator.dart)
- Rotas e guardas: [lib/app/router.dart](lib/app/router.dart)
- Configurações por flavor: [lib/app/config/app_config.dart](lib/app/config/app_config.dart)

Algumas notas de arquitetura:

- A injeção de dependências é feita com `GetIt`.
- `SessionCubit` é um singleton iniciado de forma eager em `GlossipApp`.
- Repositórios de rede usam `Dio` com interceptors em [core/network](core/network).
- Dados de exemplo e cubits de mock estão em [lib/shared/state](lib/shared/state).

## Pré-requisitos

- Flutter SDK (recomendado versão estável atual)
- Para rodar web: habilitar target `chrome` ou `edge`

## Como rodar (desenvolvimento)

1. Instale as dependências:

```bash
flutter pub get
```

2. Rodar no navegador (ex.: Chrome):

```bash
flutter run -d chrome
```

3. Rodar testes:

```bash
flutter test
```

## Configuração de runtime

O projeto usa `--dart-define` para configurar flavors e a URL do backend.

- `APP_FLAVOR`: `local`, `staging` ou `prod` (padrão `local`)
- `API_BASE_URL`: sobrescreve a URL padrão definida por flavor

Exemplo de execução com variáveis:

```bash
flutter run -d chrome --dart-define=APP_FLAVOR=local --dart-define=API_BASE_URL=http://localhost:8080/
```

## Estrutura do repositório (resumido)

- `lib/` — código-fonte da aplicação
	- `app/` — bootstrap, router, config e DI
	- `core/` — controladores, tema, utilitários e rede
	- `domain/` — modelos e repositórios por feature
	- `shared/` — componentes UI, widgets e estados mock
- `test/` — testes unitários e de widget ([test/app_config_test.dart](test/app_config_test.dart), [test/controllers_test.dart](test/controllers_test.dart))
- `web/` — assets e arquivo `index.html` para deploy web

## Desenvolvimento e contribuições

Contribuições são bem-vindas. Boas práticas:

1. Abra uma issue descrevendo o problema ou a feature.
2. Crie uma branch com prefixo `feature/` ou `fix/`.
3. Submeta um pull request com descrição clara e screenshots quando aplicável.

Dicas de desenvolvimento:

- Use `flutter analyze` para checar lint e problemas estáticos.
- Execute `flutter test` antes de abrir PRs.

## Verificação

Principais arquivos de verificação e pontos de entrada para entender o app:

- [lib/main.dart](lib/main.dart)
- [lib/app/bootstrap.dart](lib/app/bootstrap.dart)
- [lib/app/di/service_locator.dart](lib/app/di/service_locator.dart)

## Licença

Este repositório inclui um arquivo de licença: [LICENSE](LICENSE).

---

Se quiser, posso ajustar o README adicionando instruções de deploy (Vercel/Netlify), badges de CI, ou um guia de arquitetura mais detalhado. Quer que eu adicione algo específico?
