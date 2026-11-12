---
updated: 2026-11-11
fase: entrevista
---

# Preparo do projeto

Checklist do que o projeto precisa antes do `/planejar`. Você pode abri-lo antes, para saber o que
separar em `_import/`; o `/preparar` o usa como estado da entrevista (retoma de onde parou).

`fase`: `inventario` · `entrevista` · `pronto`

Status: `tem` · `parcial` · `falta` · `n/a`
Nível: **trava** (sem isso o /planejar não roda) · **ajuda** (pode ficar para depois)

| # | Item | Nível | Status | Evidência (arquivo §seção) | Destino | Em aberto |
|---|------|-------|--------|----------------------------|---------|-----------|
| 1 | Visão, problema e público | trava | tem | PRD.md §§1–3 | prd.md |  |
| 2 | Features com IDs e MoSCoW | trava | tem | PRD.md §§5–7; entrevista rodada 1 | prd.md (Features) | |
| 3 | Decisões técnicas: stack, plataformas, hospedagem, banco | trava | parcial | PRD.md §§10–11 | overview.md + ADRs | Fonte de áudio e fallback |
| 4 | Fluxos de usuário com erros e estados vazios | trava | parcial | notes-practice.md §§2–8; telas.md §§2–3 | specs/ | Estados vazios e carregamento |
| 5 | Modelo de dados e glossário | trava | parcial | notes-practice.md §13 | overview.md + specs | Glossário e persistência |
| 6 | Integrações externas (APIs, auth, limites) | trava | parcial | PRD.md §§5–6, 11 | specs + ADRs | Confirmar integrações e limites |
| 7 | Design system e tokens | trava | tem | design-system.md §§2–11 | design/design-system.md + tokens.json (PDF em design/, depois do .md) |  |
| 8 | Telas ou mockups das features Must | trava | parcial | telas.md §§2–6 | assets/design/ (imagens); PDF em design/; specs (Referência) | Algumas telas P0 não desenhadas |
| 9 | Requisitos não funcionais | ajuda | tem | PRD.md §§8, 11–12 | prd.md + specs |  |
| 10 | Textos da interface (microcopy, erros) | ajuda | parcial | telas.md §§2–3 | specs | Estados não desenhados |
| 11 | Logo, ícones, fontes | ajuda | parcial | design-system.md §§4, 8 | assets/design/ (imagens) + tokens.json | Logo e arquivos de fontes |
| 12 | Dispositivos e tamanhos de tela | ajuda | parcial | PRD.md §§8.4, 10–11 | qa/print-rules.md | Regras de prints |
| 13 | Métricas de sucesso do MVP | ajuda | tem | PRD.md §9 | prd.md |  |
| 14 | Referências e moodboard | ajuda | parcial | PRD.md §2; telas | assets/design/ (imagens); PDF em design/ | Sem moodboard |
| 15 | Dados de exemplo para testes | ajuda | parcial | telas.md §1 | issue de setup | Conjunto de testes |

- PDFs e imagens guardados são referência para pessoas; os agentes leem os `.md`. O material
  original fica em `_import/`, fora do git, e o `/preparar` pergunta se pode apagá-lo no final.
- Item que não se aplica (ex.: projeto sem integrações) → `n/a`, com o motivo em Em aberto.
- O item 3 também alimenta a issue de setup (stack) e o `.github/workflows/ci.yml` (lint e testes).
- Item `trava` que ficou `parcial` só por `> Pendente:` não impede o `pronto` se o usuário aceitar;
  o `/planejar` deixa as issues que dependem dele para depois.

## Para o /planejar

<!-- Preenchido pelo /preparar. O que o material diz sobre ordem de entrega e trabalho a fazer.
     Não é decisão: é ponto de partida para o /planejar, que decide com o usuário. -->

### Fases, milestones e ordem de entrega

| # | O que o material diz | Fonte (arquivo §seção) | Features (F#) |
|---|----------------------|------------------------|---------------|
| 1 | **M0** — **Spike de risco** (go/no-go): Monorepo (pub workspaces + FVM) e CI mínima. Protótipo descartável do **braço em Flutter**: desenho com CustomPainter, toque na célula inteira, janela dinâmica de 6 casas, retrato e paisagem, modo canhoto, som da nota (`flutter_soloud`), rodando em **Android, Linux e macOS desktop** (mouse/hover). **Tokens do design system** como `ThemeExtension` (escuro e claro) + fontes embutidas com fallback para ♯/♭. Decidir a fonte dos samples. **Ao fechar o M0: escrever `README.md` (visão, stack, como rodar, comandos) e `CLAUDE.md` (comandos, estrutura, convenções) com os comandos já testados** | roadmap-inicial.md §MVP | |
| 2 | **M1** — Núcleo de teoria: Pacote `fretboard_core` (Dart puro, sem dependências): notas, afinações, `noteAt`, `positionsOf`, oitavas, marcadores, contagem e **gerador de explicações** | roadmap-inicial.md §MVP | |
| 3 | **M2** — Motor de lição: Fases LEARN → PRACTICE → YOUR TURN, os 4 tipos de pergunta, feedback, fila de erros, **currículo de Notes 0–12** (corda por corda, naturais e sustenidos), Lesson complete com estrelas · **Telas 07–12, 14** | roadmap-inicial.md §MVP | |
| 4 | **M3** — SRS e progresso: Persistência local (`drift`), cartões por posição (1d/3d/7d/30d), **Review** (até 20), tela **Progress** (mapa + contadores + filtro + detalhe por posição) · **Telas 05, 15** | roadmap-inicial.md §MVP | |
| 5 | **M4** — Home e sessão diária: Card Today's Session (pendente/concluído), sessão de 2, 5 ou 10 min, streak semanal, Session done, **Settings**, navegação responsiva (barra inferior / lateral) · **Telas 01, 02, 06, 13** | roadmap-inicial.md §MVP | |
| 6 | **M5** — Drills: **Build your own** (todas as opções), **Speed round**, **Your drills** (menu ⋯), prática livre sem SRS · **Telas 03, 04** | roadmap-inicial.md §MVP | |
| 7 | **M6** — Afinações alternativas: Drop D, meio tom abaixo, DADGAD, Open G nos drills de notas; explicações ajustadas por afinação | roadmap-inicial.md §MVP | |
| 8 | **M7** — Release do MVP: Polimento visual, ícone, nome, i18n revisado, CI de release (runner macOS para iOS/macOS), beta fechado (Play teste interno + TestFlight) | roadmap-inicial.md §MVP | |
| 9 | **P1** — Notes completo: **Find every** (já especificado), currículo das casas **13–22** (truque "casa + 12"), lembretes diários, tour "How it works" | roadmap-inicial.md §Pós-MVP | |
| 10 | **P2** — Intervalos: m2 a oitava, shapes de intervalo no braço, achar e nomear intervalos | roadmap-inicial.md §Pós-MVP | |
| 11 | **P3** — Tríades e inversões: Maior, menor, diminuta, aumentada; fundamental, 1ª e 2ª inversão por grupo de cordas | roadmap-inicial.md §Pós-MVP | |
| 12 | **P4** — CAGED: Os 5 shapes, como eles se conectam no braço, tríades dentro de cada shape | roadmap-inicial.md §Pós-MVP | |
| 13 | **P5** — Escalas e modos: Pentatônicas, blues, maior e menor natural, modos, tudo dentro dos shapes CAGED | roadmap-inicial.md §Pós-MVP | |
| 14 | **P6+** — A definir: Arpejos, afinações alternativas no currículo, microfone para conferir a nota tocada, outros instrumentos | roadmap-inicial.md §Pós-MVP | |
| 15 | Currículo 0–12, depois 13–22; habilidades posteriores | notes-practice.md §§11, 12.1 | F2 |

### Trabalho a construir

| # | Item | Fonte (arquivo §seção) | Feature (F#) | Observação |
|---|------|------------------------|--------------|------------|
| 1 | Funcionalidades do MVP | PRD.md §7 | F1–F11 | Lista de features |
| 2 | Find every, currículo 13–22, lembretes e tour | notes-practice.md §12 | | Sem ID próprio |
| 3 | Telas ainda não desenhadas | telas.md §6 | | Relacionar às features na entrevista |

- Uma linha por trecho do material, citando a fonte, sem reescrever nem decidir nada.
- "Features" e "Feature" usam os ids `F#` do PRD; se o trecho não casa com nenhuma feature, deixe
  vazio e escreva o motivo em Observação.
- Contradições entre fontes (ex.: duas ordens diferentes) entram como linhas separadas, e a
  contradição vai para a entrevista como as outras.

## Registro da entrevista

<!-- uma linha por rodada: data, itens tratados, decisões, o que virou Pendente -->

- 2026-11-11: inventário e plano de organização aprovados; entrevista iniciada.

- 2026-11-11: rodada 1 — Ache todas pós-MVP; tema também segue sistema; português e inglês no MVP, escolha do mecanismo de idioma conforme simplicidade; F1–F11 Must.
