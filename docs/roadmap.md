---
updated: 2026-11-11
---

# Roadmap

Duas seções. **Milestones** é a visão geral, escrita pelo `/planejar` (sem argumento): todos os
milestones, só em prosa, sem tasks. **Issues por milestone** tem as tasks, e só do milestone que
já foi detalhado pelo `/planejar M<n>`: nunca existem issues de milestones futuros.

Status das issues: `todo` · `doing` · `done`. O roadmap guarda o destino de cada linha: `doing`
quando a task começa (`/implementar`) e `done` já no PR dela (`/abrir-pr`), para entrar na `main`
com o merge. O andamento real (PR aberto, issue fechada) o board mostra, pelo `./scripts/sync-board.sh`.

A ordem das linhas é a ordem de execução (a coluna Ordem é global): a primeira linha `todo` é
sempre a próxima. Linhas são criadas por `./scripts/new-issue.sh` e o status muda por
`./scripts/task-status.sh`; a coluna PR é preenchida pelo `./scripts/open-pr.sh`.

## Milestones

### M0 — Fundação e spike
- **Objetivo:** Montar a fundação e validar riscos de interação, áudio e fontes.
- **Escopo:** setup e protótipo descartável, sem atribuição de feature.
- **Critério de saída:** go/no-go: toque preciso em celular pequeno; som com latência imperceptível em Android e Linux; protótipo funcional também em macOS.
- **Depende de / decisões abertas:** fonte dos samples e fallback para ♯/♭; acesso aos dispositivos.
- **Tamanho:** G

### M1 — Núcleo de teoria e braço
- **Objetivo:** Construir teoria de notas e braço interativo.
- **Escopo:** F1.
- **Critério de saída:** cálculos cobrem 6 cordas × 23 posições na afinação padrão; explicações passam nos exemplos; braço responde ao toque e modo canhoto.
- **Depende de / decisões abertas:** go do M0; decisões de áudio e fontes.
- **Tamanho:** G

### M2 — Motor de lição
- **Objetivo:** Ensinar notas em lições com perguntas e feedback.
- **Escopo:** F2, F3.
- **Critério de saída:** todas as lições de notas 0–12 podem ser concluídas, com reapresentação de erros e estrelas.
- **Depende de / decisões abertas:** M1; detalhes de telas pendentes.
- **Tamanho:** G

### M3 — Revisão e progresso
- **Objetivo:** Persistir aprendizado e mostrar progresso.
- **Escopo:** F4, F6.
- **Critério de saída:** progresso sobrevive ao reinício; revisões vencem nas datas esperadas; mapa e filtros funcionam.
- **Depende de / decisões abertas:** M2; ADR Drift/SQLite.
- **Tamanho:** G

### M4 — Sessão diária e ajustes
- **Objetivo:** Entregar fluxo diário e preferências.
- **Escopo:** F5, F10.
- **Critério de saída:** sessão completa vai de início a conclusão com streak; ajustes persistem; PT-BR e inglês funcionam.
- **Depende de / decisões abertas:** M3; definir seleção de idioma ou idioma do sistema.
- **Tamanho:** G

### M5 — Treinos livres
- **Objetivo:** Criar, executar e gerenciar drills.
- **Escopo:** F7, F8, F9.
- **Critério de saída:** usuário cria, salva, edita, duplica, apaga e executa drills; rodada rápida respeita timer; prática livre não altera SRS.
- **Depende de / decisões abertas:** M4.
- **Tamanho:** G

### M6 — Afinações alternativas
- **Objetivo:** Oferecer afinações alternativas em drills de notas.
- **Escopo:** F11.
- **Critério de saída:** drills funcionam nas quatro afinações previstas, com notas e explicações corretas, sem alterar progresso.
- **Depende de / decisões abertas:** M5.
- **Tamanho:** M

### M7 — Release do MVP
- **Objetivo:** Preparar beta Android e iOS.
- **Escopo:** integração e release, sem atribuição de nova feature.
- **Critério de saída:** builds de beta disponíveis; uso diário por duas semanas com testers.
- **Depende de / decisões abertas:** M6; nome, ícone, acesso a lojas e build iOS.
- **Tamanho:** G

> Pendente: definir IDs de feature e critérios para as fases pós-MVP do material: Notes completo, intervalos, tríades, CAGED, escalas e fases posteriores. Find every permanece fora do MVP.

## Issues por milestone

### M0 — Fundação e spike

| Ordem | Issue | Título | Status | Spec | PR |
|---|---|---|---|---|---|
| 1 | #1 | [chore] Setup do projeto | done | — | #9 |
| 2 | #5 | [feat] Preparar temas, tokens e fontes para o spike | done | specs/braco-interativo.md | #10 |
| 3 | #6 | [feat] Prototipar interação com o braço | done | specs/braco-interativo.md | |
| 4 | #7 | [feat] Validar áudio e registrar evidências do spike | todo | specs/braco-interativo.md | |
