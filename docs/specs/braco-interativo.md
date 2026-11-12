---
feature: F1
area: pendente
updated: 2026-11-12
---

# F1 · Braço interativo

## Resumo

> O braço definitivo ainda não está implementado. O spike atual oferece uma amostra de tokens e fontes com temas escuro, claro e sistema; veja [avaliação das fontes](../spike-fontes.md). O material abaixo descreve o produto proposto.

## Rotas/Telas

## 14 · Paisagem · Pergunta

Tema escuro · "Ache o C♯ na corda A" · pág. 18

![Paisagem · Pergunta · "Ache o C♯ na corda A" · tema escuro](../assets/design/paisagem-pergunta-escuro.png)

**Objetivo**

- Validar o layout expandido da pergunta (paisagem ou tablet).

**Elementos**

- Topo: "✕" e barra de progresso em 60%, largura total.
- Braço à esquerda (60% da largura), casas 1 a 7, com a corda A inteira destacada (corda-alvo).
- Painel à direita (40%), num card: rótulo "Sua vez", pergunta "Ache o C♯ na corda A" (28 px, "C♯" e "A" com marca-texto) e "Toque no braço".
- Sem barra de abas (a lição ocupa a tela toda).

**Estado e comportamento**

- O usuário responde tocando numa casa da corda destacada (área de toque = a célula inteira). Não há botões de nota neste tipo de pergunta.
- O feedback (09 ou 11) substitui o conteúdo do painel da direita; o braço mostra o resultado como em retrato.
- No desktop, o hover destaca a casa sob o cursor. Sem atalhos de teclado.

## Estados e ações

## 1. Navegação

- **Home · Practice · Progress · Settings**. No exemplo fica numa barra lateral, em paisagem ✅
- O braço é horizontal e é o centro das telas de treino ✅
- **Viewport dinâmico** ✅: o braço não aparece inteiro durante uma pergunta. O app mostra uma janela de ~5 a 6 trastes em volta do alvo (vimos janelas 0–5, 5–9, 7–12, 9–15) e escolhe a janela a cada pergunta. Com 22 trastes isso vira obrigatório.
- **Faixa visível ≠ faixa de perguntas**: o braço é desenhado no mínimo até a **casa 15** (ou até o fim da faixa do drill, se ela passar do 15). As perguntas ficam dentro da faixa do drill (padrão 0–12). Assim as notas perto da casa 12 sempre têm contexto visual dos dois lados.

## Critérios de aceite vigentes

Nenhum comportamento implementado confirmado.

## Pendências

> Pendente: confirmar estados vazios, carregamento e erros aplicáveis.

## Decisões da entrevista — rodada 3

Se o áudio estiver indisponível, permitir continuar sem som e avisar que o app está sem som.
