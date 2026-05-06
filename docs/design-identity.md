# Identidade Visual GlossipUerj

Este projeto usa uma linguagem visual pop-art/editorial de campus. As telas de `feed`, `crushes` e `eventos` seguem o mesmo sistema: fundo forte em magenta, superfícies brancas, contornos pretos grossos, sombras duras deslocadas, tipografia pesada e pequenos gestos de irreverencia como rotacao, gradiente neon e micro-animacoes de hover.

## Essencia da marca

- Tom visual: escandaloso, jovem, divertido, assumidamente artificial e chamativo.
- Sensacao: mural universitario + tabloid + adesivos impressos + UI de revista pop.
- O app evita minimalismo neutro, vidro fosco generico e aparencia corporativa.
- Quase tudo parece "colado" sobre o fundo: cards, filtros, chips, hero labels, navegacao.

## Tokens visuais reais

Baseado em `lib/core/theme/glossip_colors.dart`, `lib/core/theme/glossip_theme.dart` e widgets compartilhados.

- `primary`: `#FF00FF`.
- `secondary`: `#00FFFF`.
- `accent`: `#FFFF00`.
- `background`: `#FF007F`.
- Superficie principal: branco puro.
- Contorno: preto puro.

Regras praticas:

- Use a paleta curta acima antes de inventar novas cores.
- Prefira branco para superficies de conteudo; use neon como destaque, nao como base de leitura longa.
- Quando precisar de cor semantica secundaria, siga o padrao de `eventCategoryColor()` e mantenha saturacao alta.

## Tipografia

- Fonte base do app: `Urbanist` via `GoogleFonts.urbanist()`.
- O tema aumenta o peso visual de quase todos os estilos em `glossip_theme.dart`; textos tendem a `w700-w900`.
- Titulos usam caixa alta, tamanhos grandes, tracking apertado/negativo e sombra dura.
- Subtitulos em destaque aparecem em faixas amarelas com contorno preto e leve rotacao.
- Texto corrido continua pesado para o padrao Flutter; evite fontes delicadas ou contrastes muito sutis.

Regras praticas:

- Para titulos: `fontWeight: w900`, caixa alta e sombra escura simples.
- Para labels e botoes: caixa alta quase sempre.
- Para corpo: preto sobre branco, peso minimo visual alto (`w700` ou `w800`).
- Nao introduza serifas, monospace ou combinacoes tipograficas sofisticadas fora de necessidade muito clara.

## Formas, bordas e sombras

O vocabulário principal vem de `GlossipCard`, `GlossipHoverCard`, `GlossipButton`, `GlossipInput`, `GlossipTag` e `GlossipSectionLabel`.

- Bordas grossas e pretas: normalmente `2`, `3` ou `4` px.
- Sombras nao sao difusas; sao chapadas, escuras e deslocadas (`Offset(4,4)`, `Offset(6,6)`, `Offset(8,8)`, `Offset(12,12)`).
- Cards comuns: retangulares, fundo branco, sem borda arredondada.
- Destaques de hover: deslocamento do foreground e troca de sombra para ciano/neon.
- Pequenas rotacoes (`0.02`, `-0.02`) aparecem em labels e chamadas para quebrar rigidez.

Regras praticas:

- Se estiver criando um bloco importante, comece por `GlossipCard` ou `GlossipHoverCard`.
- Evite `BorderRadius` como padrao. Use quinas retas, exceto quando o componente ja foge disso por intencao clara, como o blob do hero.
- Evite sombras com blur suave como linguagem principal.
- Evite superfícies sem borda; elas ficam fora do sistema visual.

## Background e profundidade

- O fundo global vem de `AppBackground`: magenta solido com padrao de pontos brancos e halos radiais ciano/amarelo.
- O conteudo principal fica sempre acima disso em camadas brancas ou amarelas.
- A profundidade vem de offset, nao de opacidade ou blur forte.

Regras praticas:

- Novos componentes devem assumir que o fundo do app ja e expressivo; nao compita com ele adicionando muitos gradientes extras.
- Use gradiente apenas em pontos de assinatura visual, como palavras-highlight de hero ou formas decorativas.

## Padroes por tela

## Feed

- Hero grande com copy editorial, palavra destacada em gradiente magenta->ciano e selo amarelo inclinado.
- Compositor dentro de `ArtPopCard` branco com inputs pesados e CTA ciano/preto.
- Filtros em botao com estado ativo forte (`primary`) e header branco enquadrado.
- Posts em `HoverArtPopCard`, categoria em etiqueta colorida, texto principal grande e pesado.
- Interacao segue linguagem de "chips impressos": like/dislike/comentar com hover deslocado.

## Crushes

- Header reaproveita `HeroTitle`, mas com destaque ciano->amarelo.
- Busca e filtros sao cards brancos grandes, com controles pretos sobre branco.
- Grid de perfis usa repeticao forte de card modular, imagem quadrada e tags compactas.
- CTA de like usa cor como estado emocional: branco inativo, magenta ativo.
- Avisos aparecem como card amarelo com CTA preto.

## Eventos

- Header reaproveita `HeroTitle` com foco mais institucional, sem perder saturacao.
- Calendario continua o sistema de cards, com celulas retangulares brancas/pretas e selected state com sombra rosa.
- Painel lateral de eventos e composto por cards aninhados, sempre com borda preta.
- Categorias viram etiquetas coloridas saturadas, mantendo contraste alto.
- Modal de novo evento e um `Dialog` transparente envolvendo `ArtPopCard` grande.

## Comportamento e interacao

- Hover existe e faz parte da identidade no desktop: escalas leves, rotacao minima, foreground deslocado, sombra colorida.
- Estados ativos devem ser inequivocos, geralmente por inversao para preto, magenta ou outro neon forte.
- Feedback visual deve ser instantaneo e grafico; evite animacoes lentas ou elegantes demais.
- No mobile, a identidade permanece pelos blocos, cores e sombras, mesmo sem hover.

## Responsividade

Baseado em `AppBreakpoints` e no uso das paginas.

- `mobile`: abaixo de `600`.
- `tablet`: abaixo de `850` com varios layouts empilhando.
- `desktop`: acima de `1000` para grades e composicoes mais abertas.
- O app normalmente reduz padding horizontal e troca `Row/Flex` por empilhamento vertical.
- Nao remova densidade visual no mobile; compacte a composicao sem neutralizar o estilo.

## Sistema de Componentes

O sistema de componentes do projeto agora deve ser a primeira escolha para UI nova e refatoracoes. O ponto de entrada preferido e:

- `lib/shared/widgets/glossip_components.dart`

Ele reexporta os blocos principais da biblioteca visual do projeto.

### Componentes base

- `GlossipCard`: card base do sistema para superficies de conteudo.
- `GlossipHoverCard`: card com hover deslocado para desktop/web, mantendo leitura boa no touch.
- `GlossipButton`: CTA principal e secundario.
- `GlossipIconButton`: botao quadrado de icone com area de toque consistente.
- `GlossipIconTileButton`: botao compacto com foco em acoes de grade/lista.
- `GlossipChipButton`: acao curta estilo chip impresso.
- `GlossipMiniChipButton`: chip compacto para acoes pequenas.
- `GlossipDialog`: casca base para modais do sistema.
- `GlossipDialogHeader`: cabecalho padrao de modal.
- `GlossipConfirmationDialog`: substituto de dialogos simples de confirmacao.
- `GlossipInput`: container visual de campo.
- `GlossipGlassField`: campo visual mais leve usado em auth quando necessario.
- `GlossipSelectField`: select base.
- `GlossipLabeledSelectField`: select com label do sistema.
- `GlossipLabeledTextField`: campo de texto com label do sistema.
- `GlossipFieldLabel`: label pesada de formularios.
- `GlossipHeroTitle`: hero title reutilizavel para paginas.
- `GlossipPageHeader`: cabecalho padrao de pagina interna.
- `GlossipSectionLabel`: selo inclinado para secoes.
- `GlossipTag`: tag compacta.
- `glossipBoxDecoration()`: decoracao base para casos em que ainda nao vale extrair um widget novo.

### Mapeamento mental em vez de Material

- Em vez de `Card`, use `GlossipCard`.
- Em vez de um card hover manual, use `GlossipHoverCard`.
- Em vez de `AlertDialog` ou `Dialog` cru, use `GlossipDialog` ou `GlossipConfirmationDialog`.
- Em vez de `TextButton`, `ElevatedButton`, `FilledButton` ou `OutlinedButton`, comece por `GlossipButton`.
- Em vez de `IconButton` customizado ad hoc, use `GlossipIconButton`.
- Em vez de chips montados manualmente, use `GlossipChipButton` ou `GlossipMiniChipButton`.
- Em vez de `DropdownButton` solto, use `GlossipSelectField` ou `GlossipLabeledSelectField`.
- Em vez de montar label + campo toda vez, use `GlossipLabeledTextField`.

Material continua valendo quando o componente ainda nao existe no sistema e quando a camada Material resolver infraestrutura que nao estamos substituindo, como:

- `ScaffoldMessenger`
- `SnackBar`
- `CircularProgressIndicator`
- `ListView`, `GridView`, `SafeArea`, `Scaffold`

Mesmo nesses casos, a casca visual em volta deve preferir componentes Glossip.

### Como importar

Para telas e componentes de interface, prefira importar o barrel:

```dart
import "package:flutter_app/shared/widgets/glossip_components.dart";
```

Isso evita importar arquivos pontuais do sistema visual e ajuda a manter a API consistente.

### Regras de contribuicao

- Antes de criar um widget visual novo, verifique se ele e apenas uma composicao de componentes `Glossip*` ja existentes.
- Se voce precisar repetir a mesma composicao em duas ou mais telas, extraia um novo componente `Glossip*`.
- Nao introduza novos wrappers visuais baseados diretamente em Material se o comportamento puder nascer de `GlossipCard`, `GlossipButton`, `GlossipDialog` e campos do sistema.
- Evite nomes sem prefixo. Componentes do design system devem usar prefixo `Glossip`.
- Mantenha compatibilidade touch-first: hover pode enriquecer, mas nunca pode ser necessario para descobrir a acao.
- Pense em Android desde agora: alvos de toque confortaveis, contrastes fortes e layouts que funcionem sem cursor.

### Android e multiplataforma

- Considere `48x48` como referencia minima para areas tocaveis de botoes pequenos.
- Estados ativos, foco e disabled devem ser visiveis sem hover.
- Dialogos devem continuar legiveis em telas estreitas; prefira conteudo rolavel em vez de altura fixa.
- Nao use gestos dependentes de hover como unica forma de revelar a interface.
- Quando precisar de animacao, prefira movimentos curtos e claros que funcionem igual em web e mobile.

## Como construir novos componentes sem sair da identidade

Sequencia recomendada:

1. Comece por um container do sistema: `GlossipCard`, `GlossipHoverCard`, `GlossipInput`, `GlossipButton` ou `glossipBoxDecoration()`.
2. Escolha uma hierarquia curta de cores: branco para base, preto para estrutura, 1 neon para destaque.
3. Use tipografia pesada e caixa alta em titulos, labels e CTAs.
4. Introduza no maximo um gesto expressivo: gradiente, rotacao leve, selo, badge ou hover deslocado.
5. Verifique se o componente continua legivel sobre o fundo magenta do app.

Checklist rapido:

- O componente parece parte do mesmo universo de cards impressos?
- Existe contorno preto suficiente para separacao?
- A sombra e chapada/deslocada em vez de suave?
- O destaque de cor usa a paleta do produto?
- O texto principal continua legivel e pesado?
- O resultado evita aparencia corporativa ou genérica?

## Do

- Reutilize `GlossipHeroTitle`, `GlossipSectionLabel`, `GlossipTag`, `GlossipButton`, `GlossipInput` e `GlossipCard` antes de criar variantes novas.
- Use contraste alto: preto/branco/neon.
- Faça CTAs parecerem objetos fisicos impressos.
- Mantenha a pagina energetica, divertida e um pouco exagerada.

## Don't

- Nao use cards cinza discretos com sombra suave padrão Material.
- Nao use gradientes por toda parte.
- Nao aplique cantos arredondados por default.
- Nao troque a paleta neon por tons pasteis ou corporativos.
- Nao reduza os pesos tipograficos para um visual delicado.
- Nao introduza componentes muito "clean" que parecam de outro design system.

## Referencias de codigo

- Tokens: `lib/core/theme/glossip_colors.dart`
- Tema tipografico: `lib/core/theme/glossip_theme.dart`
- Fundo global: `lib/shared/layout/app_background.dart`
- Barrel do sistema: `lib/shared/widgets/glossip_components.dart`
- Cards e sombras: `lib/shared/widgets/art_pop_card.dart`
- Dialogos: `lib/shared/widgets/dialogs.dart`
- Botoes: `lib/shared/widgets/buttons.dart`
- Inputs: `lib/shared/widgets/form_fields.dart`
- Titulos e labels: `lib/shared/widgets/labels.dart`
- Exemplos de paginas: `lib/features/feed/presentation/feed_page.dart`, `lib/features/crushes/presentation/crushes_page.dart`, `lib/features/events/presentation/events_page.dart`
