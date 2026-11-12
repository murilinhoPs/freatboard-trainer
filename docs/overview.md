# Visão geral

## 2. Proposta

Um app mobile (Android e iOS, testado também em Linux e macOS desktop) que ensina as notas do braço **corda por corda**, com lições curtas, **revisão espaçada por posição** e drills de prática livre. Uma sessão diária de poucos minutos mantém o progresso. Depois do MVP, o mesmo motor ensina intervalos, tríades, CAGED e escalas.

Referência principal: Fretboard Trainer (iOS).

## 3. Público

- **Primário:** guitarristas iniciantes e intermediários que tocam acordes e tablaturas, mas não sabem onde ficam as notas.
- **Secundário:** quem estuda teoria (escalas, campo harmônico) e quer ligar a teoria ao braço.
- Brasileiros primeiro (PT-BR), com inglês preparado.

## 10. Plataformas

| Plataforma | Papel no MVP |
|---|---|
| **Android** | Alvo principal de lançamento (Play Store) |
| **iOS** | Alvo de lançamento (TestFlight → App Store); o build exige um Mac ou um runner macOS na CI |
| **Linux desktop** | **Plataforma de desenvolvimento e teste** (máquina principal: CachyOS). Roda o app inteiro, os testes de integração e as goldens |
| **macOS desktop** | **Plataforma de teste** (layout expandido, mouse); a distribuição fica para depois |
| Web / Windows | Fora do MVP |

### 10.1 O que muda no desktop
- **Entrada:** só mouse no MVP. O **hover** destaca a célula sob o cursor (`board-hi` com opacidade reduzida). Atalhos de teclado ficaram **fora por enquanto** (decisão do design system); candidatos para depois: `C`–`B` para responder, `Enter` = Continuar, `Esc` = sair.
- **Janela redimensionável:** o layout segue o mesmo breakpoint por largura (compacto < 600 dp / expandido). No desktop, isso também testa o layout de tablet.
- **Haptics:** não há no desktop. O `HapticFeedback` vira no-op, então o feedback não pode depender dele.
- **Notificações (P1):** `flutter_local_notifications` cobre Linux e macOS, mas o MVP não depende delas.
- **Tamanho mínimo da janela:** ~360 × 640, para simular um celular pequeno no M0.

## 11. Stack e ferramentas

### 11.1 Base
| Item | Escolha | Por quê |
|---|---|---|
| SDK | **Flutter stable 3.50** (nov/2026) + Dart 3.x, versão fixada com **FVM** | O mesmo SDK em todas as máquinas e na CI |
| Estrutura | **Pub workspaces** (monorepo): `packages/fretboard_core` (Dart puro) + `app/` (Flutter) | O núcleo de teoria fica isolado e testável com `dart test`, sem Flutter |
| Design system | **Tema próprio "Caderno neon"** sobre o **`material_ui`** (pacote standalone) | O Material entra só como base estrutural (Scaffold, navegação, acessibilidade). Os componentes visuais (botões com sombra dura, chips, cards, opções, braço) são widgets próprios lidos dos tokens |
| Lint | `flutter_lints` + regras estritas (`strict-casts`, `strict-raw-types`) | Padrão oficial; o código gerado por agente fica consistente |

### 11.2 App
| Área | Pacote | Notas |
|---|---|---|
| Estado / DI | **`flutter_riverpod` 3.x** | Notifiers por feature (sessão, drill, progresso); overrides facilitam os testes |
| Navegação | **`go_router`** | Shell com as 4 abas; rotas das sessões em tela cheia |
| Persistência | **`drift`** (+ `drift_flutter`, SQLite) | Tipado, com migrations e streams reativos; roda em Android, iOS, Linux e macOS sem setup extra |
| Áudio | **`flutter_soloud`** | Baixa latência, Android/iOS/Linux/macOS; samples pré-carregados na memória |
| i18n | **`flutter_localizations` + `gen-l10n` (ARB)** | Oficial. `app_pt.arb` e `app_en.arb` no MVP |
| Haptics | `HapticFeedback` (SDK) | No-op no desktop |
| Notificações (P1) | `flutter_local_notifications` | Lembrete diário |
| Tokens de design | **`ThemeExtension`** (`AppTokens`: cores por tema, espaçamentos, raios, bordas, sombras, tipografia) | Gerados a partir do **JSON de tokens** do design system (script simples ou escritos à mão no M0); o tema escuro/claro só troca a extensão |
| Fontes | **Space Grotesk** + **Atkinson Hyperlegible** como assets (TTF, OFL) + `fontFamilyFallback` para ♯/♭ | Sem `google_fonts` em runtime: tudo offline e com goldens estáveis |
| Ícones | **SVG do design system** via `flutter_svg` (ou `vector_graphics` pré-compilado) | ~20 ícones de traço 2,2 px; cor via `currentColor` → `ColorFilter` |
| Fundo quadriculado e sombra dura | Widgets próprios (`CustomPainter` / `BoxShadow` sem blur) | O Material não tem esses efeitos |

**Samples de áudio:** uma nota por altura, de **E2 a D6** (corda E grave solta até a casa 22 da corda e aguda; ~47 arquivos), em **WAV ou OGG**. Evitar AAC/M4A: no Linux esses formatos dependem do FFmpeg do sistema. A fonte precisa ter licença livre (CC0) ou ser gerada a partir de um SoundFont livre. ⚠️ A fonte dos samples é uma decisão do M0.

### 11.3 Núcleo `fretboard_core` (Dart puro)
- **Zero dependências** de runtime (no máximo `meta`). Modelos com `sealed class`, records e `==` explícito, sem geração de código.
- Tudo o que é regra fica aqui: teoria, gerador de perguntas, gerador de explicações, SRS, regras de sessão e estrelas.
- O app só desenha e persiste. Isso permite testar 100% das regras sem emulador.

### 11.4 Testes
| Nível | Ferramenta | Onde roda |
|---|---|---|
| Unitário (núcleo) | `package:test` | `dart test` em qualquer lugar; meta de cobertura ≥ 90% |
| Explicações | Snapshot dos textos gerados (arquivo de referência versionado) | Junto com o unitário |
| Widget | `flutter_test` | Linux |
| Golden (visual) | `matchesGoldenFile`, com fontes embutidas, **nos dois temas** e nos dois breakpoints (390 × 844 e 844 × 390) | **Só na CI Linux**, para as imagens não variarem entre máquinas |
| Contraste dos tokens | Teste unitário que calcula o contraste de cada par `cor` / `on-cor` e texto/fundo | Falha se algum par cair abaixo de AA |
| Integração (fluxos) | `integration_test` | **Linux desktop** (rápido, sem emulador) + 1 device Android antes de cada release |

### 11.5 CI/CD (GitHub Actions)
- **A cada PR** (runner Ubuntu): `analyze` · `dart test` (núcleo) · `flutter test` (widget + golden) · `integration_test` no Linux desktop (via xvfb) · `flutter build apk --debug` · `flutter build linux`
- **Release / manual:** runner macOS para `flutter build macos` e `flutter build ipa`; Android `appbundle` assinado
- **Distribuição do beta (M7):** Play Console (teste interno) + TestFlight. ⚠️ `fastlane` é opcional

### 11.6 Ambiente e fluxo de trabalho
- Desenvolvimento em **CachyOS (Linux)**, rodando como desktop Linux + device/emulador Android
- iOS e macOS são buildados e testados num Mac ou no runner macOS da CI
- Fluxo do **docs-lite-template**: `docs/` é a fonte da verdade, issues por milestone e Claude Code implementando
- Assets de design vêm do Claude Design (seção de design em `docs/design-brief.md`)

## Modelo de domínio

## 13. Modelo de domínio (Dart puro)

```dart
// Teoria
enum PitchClass { c, cs, d, ds, e, f, fs, g, gs, a, as_, b }
class Tuning { final String name; final List<PitchClass> openStrings; } // Standard, Drop D…
class Instrument { final Tuning tuning; final int frets; }               // frets = 22
class Position { final int string; final int fret; }                    // string 0 = E grave
PitchClass noteAt(Instrument i, Position p);
List<Position> positionsOf(Instrument i, PitchClass n, FretRange r);
Position? octaveOf(Instrument i, Position p);       // +2 cordas, +2 ou +3 trastes
List<PitchClass> countPath(PitchClass from, PitchClass to);
int? inlayIndex(int fret);                          // 3,5,7,9,12… → 1º, 2º dot

// Perguntas
sealed class Question { Position get target; }
class FindOnString extends Question { PitchClass note; int string; }
class FindAtFret   extends Question { PitchClass note; int fret; }
class OpenString   extends Question { int string; }
class NameNote     extends Question { List<PitchClass> options; }
class FindEvery { PitchClass note; FretRange range;          // alvos = positionsOf(...)
  Set<Position> found; int wrongTaps; bool revealed; }       // firstTry = wrongTaps==0 && !revealed
Explanation explain(Question q, {Position? tapped});  // gera o texto do feedback

// Currículo
class Lesson { String id; Skill skill; List<Position> targets; List<LearnStep> steps; }

// Progresso / SRS
enum CardState { unseen, learning, known }
class PositionCard { Position position; int intervalDays; DateTime? due; int lapses; }
class Attempt { Position position; bool correct; bool firstTry; Duration time; bool timedOut; }

// Treino
enum Direction { both, findTheNote, nameTheNote }
class DrillConfig {
  Skill skill; Set<int> strings; NoteSet notes; FretRange frets; int length;
  Tuning tuning; Direction direction; Duration? timer; String? name;
}
const defaultFrets = FretRange(0, 12);              // padrão de todo drill (faixa de perguntas)
const minVisibleFret = 15;                          // o braço sempre é desenhado até aqui
int visibleEnd(FretRange r) => max(r.end, minVisibleFret);
const speedRound = DrillConfig(/* todas as cordas, 0–12, 20, 3s */);
class SessionResult { int answered; double firstTryRate; Duration time; }
```

## Glossário

> Pendente: confirmar termos e definições do domínio.

## Falha de persistência

Se progresso ou ajustes não puderem ser salvos, mostrar erro e permitir tentar novamente. Verificar possível falta de permissão do usuário ou do sistema.

## Dados locais

Progresso, configurações e treinos salvos ficam no dispositivo; o MVP não possui conta nem sincronização. Enquanto os dados locais carregam, mostrar shimmer.
