---
status: draft
updated: 2026-11-11
---

# PRD

## 1. Problema

Quase todo guitarrista sabe que deveria conhecer as notas do braço, mas não conhece. Decorar é chato, e os métodos comuns (tabelas, apps de referência) mostram as notas sem treinar a lembrança. Os apps que treinam de verdade são quase todos em inglês, só para iOS e por assinatura.

## 2. Proposta

Um app mobile (Android e iOS, testado também em Linux e macOS desktop) que ensina as notas do braço **corda por corda**, com lições curtas, **revisão espaçada por posição** e drills de prática livre. Uma sessão diária de poucos minutos mantém o progresso. Depois do MVP, o mesmo motor ensina intervalos, tríades, CAGED e escalas.

Referência principal: Fretboard Trainer (iOS).

## 3. Público

- **Primário:** guitarristas iniciantes e intermediários que tocam acordes e tablaturas, mas não sabem onde ficam as notas.
- **Secundário:** quem estuda teoria (escalas, campo harmônico) e quer ligar a teoria ao braço.
- Brasileiros primeiro; interface em português e inglês no MVP.

## 4. Objetivos do MVP

1. O usuário aprende as **notas naturais e os sustenidos das 6 cordas, nas casas 0–12**.
2. Ele pratica **todo dia por poucos minutos** (sessão de 2, 5 ou 10 min com streak).
3. Ele **vê o progresso** no mapa do braço.
4. Ele pode **montar os próprios treinos** (Build your own, Speed round, drills salvos).

## 5. Não-objetivos do MVP

- Intervalos, tríades, CAGED, escalas e arpejos (são fases pós-MVP)
- Microfone ou detecção da nota tocada
- Conta, login, sync na nuvem ou backend
- Baixo, ukulele ou guitarra de 7 cordas
- Monetização

## 6. Princípios

- **Offline e local:** tudo funciona sem internet; os dados ficam no aparelho.
- **Lembrar, não reconhecer:** a prova é sem dicas. As dicas existem só na fase de treino.
- **Explicações geradas por código:** os truques (contagem, oitava, marcadores do braço) saem do núcleo de teoria, não de textos escritos à mão.
- **Um motor, várias habilidades:** lição, SRS e drills são genéricos por `Skill`, e Notes é a primeira.
- **Sessões curtas:** a sessão do dia cabe em 2 a 10 minutos.

## Escopo (MoSCoW)

### Must

- F1–F11.

### Should / Could

- Nenhuma feature definida nesta rodada.

### Won’t no MVP

- Ache todas (Find every); telas podem reservar espaço para ativação futura.

## Features

| ID | Feature | Prioridade | Spec | Área |
|---|---|---|---|---|
| F1 | Braço interativo | Must | [specs/braco-interativo.md](specs/braco-interativo.md) | <área a definir> |
| F2 | Lições de Notes | Must | [specs/licoes-notes.md](specs/licoes-notes.md) | <área a definir> |
| F3 | Tipos de pergunta | Must | [specs/tipos-pergunta.md](specs/tipos-pergunta.md) | <área a definir> |
| F4 | Revisão espaçada | Must | [specs/revisao-espacada.md](specs/revisao-espacada.md) | <área a definir> |
| F5 | Sessão do dia | Must | [specs/sessao-do-dia.md](specs/sessao-do-dia.md) | <área a definir> |
| F6 | Progresso | Must | [specs/progresso.md](specs/progresso.md) | <área a definir> |
| F7 | Build your own | Must | [specs/build-your-own.md](specs/build-your-own.md) | <área a definir> |
| F8 | Speed round | Must | [specs/speed-round.md](specs/speed-round.md) | <área a definir> |
| F9 | Your drills | Must | [specs/your-drills.md](specs/your-drills.md) | <área a definir> |
| F10 | Settings | Must | [specs/settings.md](specs/settings.md) | <área a definir> |
| F11 | Afinações alternativas | Must | [specs/afinacoes-alternativas.md](specs/afinacoes-alternativas.md) | <área a definir> |

## Design, métricas e plataformas

## 8. Design e experiência

Direção visual: **"Caderno neon"**. Fonte da verdade: [`design-system.md`](design-system.md).

### 8.1 Princípios de design
1. **O braço é o protagonista.** Nada na tela compete com ele em cor, brilho ou movimento.
2. **Cara de caderno, energia de jogo:** fundo quadriculado (linha de 1 px a cada 20 px), contorno "tinta" de 2 px e **sombra dura deslocada** (sem blur). Cores vivas só onde há significado.
3. **O feedback nunca depende só de cor:** acerto e erro mudam forma + ícone + texto.
4. **Dois temas de primeira classe:** **escuro é o padrão**, claro completo. Nenhum componente tem cor fixa; tudo sai de tokens.
5. **Contraste AA** e alvos de toque ≥ 44 × 44.

### 8.2 Cores semânticas (resumo)
| Papel | Token | Uso |
|---|---|---|
| Acento | `accent` | Botão primário, seleção, progresso, rótulos de seção |
| Alvo | `target` (amarelo, igual nos 2 temas) | Marcador "?", tags ("~5 min", "Foco"), streak |
| Acerto / conhecida | `ok` + `ok-soft` | Nota certa, painel de acerto, card "Feito", posição conhecida |
| Erro | `err` + `err-soft` | Nota errada, painel de erro, ações destrutivas |
| Aprendendo | `learn` | Só contorno e texto no mapa |
| Braço | `board`, `board-hi`, `fret`, `string`, `inlay` | Casas, corda-alvo, trastes, cordas, marcadores |

Não existe cor de "aviso". Os valores por tema estão no JSON de tokens do design system.

### 8.3 Tipografia
- **Space Grotesk** (500/700): títulos, nomes de nota, números, botões
- **Atkinson Hyperlegible** (400/700): texto corrido, chips, rótulos, abas
- As duas têm licença OFL e vão **embutidas como assets** (sem baixar em runtime). Escala de 12 a 40 px; nada abaixo de 12.
- ⚠️ Nenhuma das duas tem os glifos **♯ ♭**: é preciso definir uma fonte de fallback com esses símbolos.

### 8.4 Layout
- Breakpoint **600 dp**: compacto (retrato, barra inferior) / expandido (paisagem, tablet, desktop; rail lateral de 76 px)
- Referências: **390 × 844** (compacto) e **844 × 390** (expandido)
- Pergunta em paisagem: braço 60% · painel 40%
- Margens: 16 px nas abas, 20 px nos painéis de pergunta e feedback

### 8.5 Braço (requisitos de UI)
- 6 cordas com 40 px por linha e espessuras diferentes (e/B 1 · G/D 2 · A/E 3), E grave embaixo
- Coluna de corda solta (44 px) tocável; pestana de 6 px; marcadores nas casas 3/5/7/9/15/17/19/21 e duplo na 12
- **Janela dinâmica de 6 casas** nas perguntas (~56 px por casa a 390 de largura, mínimo 44), deslizando em ≤ 250 ms
- **A célula inteira (casa × corda) é a área de toque**, não só o marcador
- 12 estados de posição (vazia, alvo, corda-alvo, referência, nota da lição, acerto, erro, revelada, conhecida, aprendendo, selecionada, hover)
- Canhoto espelha só no eixo horizontal; a ordem das cordas não muda

### 8.6 Movimento, som e haptics
- Animações ≤ **250 ms** e nenhuma atrasa a próxima pergunta
- Haptic: um pulso leve no acerto, duplo no erro (no-op no desktop)
- O feedback sempre espera o toque em Continuar/Entendi

### 8.7 Acessibilidade
- Contraste ≥ 4,5:1 (3:1 a partir de 24 px) nos dois temas
- Rótulos semânticos em botões de ícone ("Sair da lição", "Opções de <drill>")
- Barra de progresso exposta com valor atual e máximo; painel de feedback **anunciado** ao leitor de tela (live region)
- Chips e segmentados expõem o estado selecionado; mapa do braço rolável com foco e rótulo

### 8.8 Escrita
- PT-BR, segunda pessoa, curto ("Você tocou D.", "Toque no braço")
- Acerto com títulos variados; erro **sempre "Quase"**, nunca "Errado"
- ♯ (U+266F) e ♭ (U+266D) tipográficos, nunca "#"/"b"; horários em 24 h
- **Sem emoji na interface**: ícones de traço no lugar

## 9. Métricas de sucesso

Medidas localmente no MVP, sem analytics remoto.

| Métrica | Meta inicial |
|---|---|
| Notas 0–12 conhecidas (verdes) após 30 dias de uso | ≥ 50% das posições |
| Acerto de primeira nas Reviews | ≥ 85% |
| Tempo médio de resposta em posições conhecidas | < 2 s |
| Dias com sessão concluída na semana (uso pessoal) | ≥ 5 |

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

## Riscos e questões abertas

## 12. Riscos

| Risco | Mitigação |
|---|---|
| O braço fica apertado demais em retrato (casas pequenas para tocar) | Janela dinâmica de 6 casas (~56 px cada a 390 de largura, mínimo 44) e toque na célula inteira; validar no M0 |
| Latência do som da nota ao tocar | `flutter_soloud` + samples pré-carregados; medir no M0 em Android e Linux |
| Comportamento diferente entre plataformas (áudio no Linux, SQLite, fontes) | Integração rodando no Linux desktop em toda PR; checklist manual em Android/iOS/macOS antes do release |
| Glifos ♯/♭ ausentes nas fontes do design system (altura e alinhamento diferentes por plataforma) | Fonte de fallback com símbolos musicais definida no M0 + goldens das notas com sustenido |
| Componentes próprios (sem Material) aumentam o trabalho de acessibilidade | Checklist de `Semantics` por componente; testes de semântica nos widgets principais |
| Pacotes ainda migrando para o `material_ui` | Isolar o tema e os componentes numa camada própria; trocar o import é mecânico (`dart fix`) |
| Explicações geradas soam estranhas em casos-limite (corda B, afinações abertas) | Testes de snapshot das explicações no M1 |
| Escopo cresce antes do MVP fechar | Fases pós-MVP só começam depois do M6 |

## 13. Em aberto (fora do produto)

- [ ] Nome do app
- [ ] Monetização pós-MVP (grátis, compra única ou assinatura)
- [ ] Publicação nas lojas: Play Store primeiro, ou as duas juntas?
- [ ] Campo de texto com erro: o design system marca como "a confirmar" (não desenhado)

## Milestones

Ver [roadmap](roadmap.md).

## Decisões da entrevista

- Ache todas fica para pós-MVP; telas podem preparar espaço para a funcionalidade futura.
- Tema: Escuro, Claro e Seguir o sistema.
- Idiomas do MVP: português e inglês, com internacionalização. Escolha entre seletor de idioma e idioma do sistema depende da opção mais simples na stack.
