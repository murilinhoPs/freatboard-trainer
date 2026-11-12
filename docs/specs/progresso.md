---
feature: F6
area: pendente
updated: 2026-11-11
---

# F6 · Progresso

## Resumo

> Pendente: confirmar comportamento vigente; material descreve produto proposto.

## Rotas/Telas

### 2.5 Progresso

![Progresso](../assets/design/progresso-posicao-selecionada-escuro.png)

**O que é:** o mapa de tudo que o usuário já sabe no braço.

**Como funciona:**
- Dois números: "**42 de 78** notas que você sabe" e "**12 de 65** lições feitas". (78 = 6 cordas × 13 posições de 0 a 12.)
- Segmentado **Casas 0–12 / Braço todo** muda o trecho do mapa.
- **Seu braço:** cada posição mostra
  - **Conhecida** = círculo preenchido verde (intervalo de revisão ≥ 1 semana);
  - **Aprendendo** = só contorno ciano;
  - **Vazia** = ainda não vista.
  - Legenda embaixo.
- Em retrato o mapa **rola na horizontal**.
- **Detalhe da posição:** tocar numa nota marca a posição (anel duplo) e mostra o card embaixo: nota, "Corda A, casa 3", "9 de 10 acertos · próxima revisão em 5 dias".

## Estados e ações

## 7. Progress ✅

- Chips: "**X of N notes you know**" e "**Y of M lessons done**".
- A unidade de progresso é a **posição (corda + traste)**. No exemplo, N = 6 × 13 = 78 (trastes 0–12).
- **Your neck**: ● verde = conhecida · ○ contorno = aprendendo · vazio = não vista.
- **No nosso app** (22 trastes): N = 6 × 23 = **138 posições**.
  - Filtro "**0–12 / braço todo**" no mapa e nos chips, com **0–12 como padrão** (igual aos drills). No padrão, o mapa é **desenhado até a casa 15** e conta só as posições 0–12.
  - Mapa com rolagem horizontal em retrato; em paisagem cabe inteiro se houver espaço.
- Posição **conhecida** = intervalo SRS ≥ 7 dias.

## Critérios de aceite vigentes

Nenhum comportamento implementado confirmado.

## Pendências

> Pendente: confirmar estados vazios, carregamento e erros aplicáveis.
