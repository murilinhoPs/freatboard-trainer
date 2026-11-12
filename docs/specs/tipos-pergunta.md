---
feature: F3
area: pendente
updated: 2026-11-11
---

# F3 · Tipos de pergunta

## Resumo

> Pendente: confirmar comportamento vigente; material descreve produto proposto.

## Rotas/Telas

## 08 · Lição · Treinar

Tema escuro · Pergunta "Que nota é essa?" · pág. 10

![Lição · Treinar · Pergunta "Que nota é essa?" · tema escuro](../assets/design/licao-treinar-escuro.png)

**Objetivo**

- Segunda fase ("Tente"): perguntar com ajuda, usando notas de referência e dica.

**Elementos**

- Topo fixo: "✕" e barra de progresso em 40%.
- Braço com janela das casas 3 a 8: alvo amarelo "?" com brilho na corda A, casa 6; referências "C", "D", "E", "F" nas casas 3, 5, 7 e 8.
- Rótulo "Treino" e link "Dica" (15 px, lilás) com ícone de lâmpada, à direita.
- Pergunta "Que nota é essa?" (30 px) e subtítulo "As notas vizinhas ficam no braço para te ajudar." (15 px).
- Quatro opções em grade 2 × 2 com gap de 16 px (60 px de altura, contorno de tinta e sombra roxa de 3 px): "C♯", "D♯", "F♯", "G♯".

**Estado e comportamento**

- Um toque numa opção responde, sem confirmação, e a nota soa. "D♯" (certa) abre 09; as outras abrem 11.
- "Dica" mostra uma frase de ajuda sem dar a resposta [a confirmar: visual da dica não desenhado].
- Outros tipos de pergunta usam o mesmo layout trocando o texto e a interação: "Ache o A na corda G", "Ache o B na casa 12" e "Toque na corda B solta" respondem tocando no braço (ver 14).

Tema claro · pág. 11: mesma tela em tema claro (`../assets/design/licao-treinar-claro.png`).

## 09 · Lição · Acerto

Tema escuro · Feedback de acerto · pág. 12

![Lição · Acerto · Feedback de acerto · tema escuro](../assets/design/licao-acerto-escuro.png)

**Objetivo**

- Confirmar a resposta certa e reforçar o truque antes da próxima pergunta.

**Elementos**

- Topo fixo: "✕" e barra de progresso em 50%.
- Braço: a nota certa "D♯" vira círculo verde com brilho na casa 6 da corda A, e a corda A fica verde e mais grossa (4 px) da pestana até a nota. Referências "D", "E", "F".
- Painel de feedback (metade inferior, fundo `#12281F`, borda superior de 2 px): selo circular verde de 44 px com ✓; título "Certo" (30 px); "É um D♯" (20 px); "Uma casa acima do D, que fica na casa 5. Sustenido é sempre a casa seguinte." (16 px); botão primário "Continuar".

**Estado e comportamento**

- O título varia, sempre sem exclamação: "Certo", "Boa", "Isso aí", "Mandou bem".
- Na fase Treinar o painel traz a explicação; em Sua vez (10) só o título e a nota.
- Haptic leve ao aparecer. "Continuar" leva à próxima pergunta.

## 10 · Lição · Sua vez

Tema escuro · Pergunta com 12 opções · pág. 13

![Lição · Sua vez · Pergunta com 12 opções · tema escuro](../assets/design/licao-sua-vez-12-opcoes-escuro.png)

**Objetivo**

- Terceira fase ("Prove"): perguntar sem ajuda. Também é o formato das revisões.

**Elementos**

- Topo fixo: "✕" e barra de progresso em 70%.
- Braço com janela das casas 1 a 6 e só o alvo "?" na corda A, casa 4 (sem referências).
- Rótulo "Sua vez" (sem link de dica).
- Pergunta "Que nota é essa?" (30 px).
- Doze opções em grade 4 × 3, ordem cromática: "C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B".

**Estado e comportamento**

- Lição com sustenidos ou bemóis: 12 opções (esta imagem). Lição só de notas naturais: 7 opções, "C" a "B", em grade de 4 colunas.
- "C♯" (certa) abre o acerto (09, sem explicação longa); as outras abrem 11.
- Revisões alimentam a repetição espaçada; drills livres não.

## 11 · Lição · Erro

Tema escuro · Feedback de erro · pág. 14

![Lição · Erro · Feedback de erro · tema escuro](../assets/design/licao-erro-escuro.png)

**Objetivo**

- Mostrar o que foi tocado, onde estava a nota certa e por quê.

**Elementos**

- Topo fixo: "✕" e barra de progresso em 70%.
- Braço com a corda A destacada: a nota tocada "D" como quadrado arredondado rosa na casa 5 e a certa "D♯" como círculo tracejado (revelada) na casa 6.
- Painel de feedback (fundo `#2B1420`, borda superior de 2 px): selo quadrado rosa de 44 px com ✕; título "Quase" (30 px); "Você tocou D" (20 px); "O D♯ fica uma casa acima do D: casa 6 da corda A. Ele volta mais tarde nesta sessão." (16 px); botão primário "Entendi".

**Estado e comportamento**

- Quando o tempo acaba (drills com tempo), a segunda linha vira "É um A".
- Haptic duplo ao aparecer. "Entendi" leva à próxima pergunta; a errada volta para o fim da fila.

Tema claro · pág. 15: mesma tela em tema claro (`../assets/design/licao-erro-claro.png`).

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

## 4. Tipos de pergunta e feedback ✅

| Tipo | Enunciado | Interação |
|---|---|---|
| Find on string | "Find **A** on the **B** string" / "…on the **high E** string" | Tocar no traste; a corda-alvo fica destacada |
| Find at fret | "Find **B** at the **12th fret**" | Tocar na corda certa daquele traste |
| Open string | "Tap the open **B** string" | Círculos de corda solta aparecem depois da pestana |
| Name the note | "What note is this?" + marcador **?** | Botões: 4 (PRACTICE) ou 7 (demais) |

**Feedback**
- **Acerto**: card verde com título variado sem exclamação ("Certo", "Boa", "Isso aí", "Mandou bem") e "É um X" A nota fica verde, e uma linha sai da pestana até ela.
- **Erro (tocou errado)**: "Not quite · You tapped G♯." A tocada aparece em vermelho e a correta em verde.
- **Erro (tempo esgotado)**: "Not quite · It's A." (sem "You tapped")
- **Explicação do erro**, gerada a partir de 3 padrões:
  1. *Contagem a partir de uma âncora*: "Count up from G on fret 8: G → G♯ → A". Se não há nota entre as duas, avisa: "B and C have no note between them".
  2. *Oitava*: "It's the octave of A on the D string (fret 7): **two strings up, two frets higher**". Quando a oitava cruza a corda B, vira **três** trastes.
  3. *Marcadores (dots)*: "C sits on the **second dot** of the G string, fret 5."
- Botão vermelho **Got it**.

> Os três padrões são computáveis no núcleo de teoria. Não precisa escrever explicação à mão para cada posição.

## Critérios de aceite vigentes

Nenhum comportamento implementado confirmado.

## Pendências

> Pendente: confirmar estados vazios, carregamento e erros aplicáveis.
