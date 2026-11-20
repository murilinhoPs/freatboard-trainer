---
feature: F2
area: pendente
updated: 2026-11-20
---

# F2 · Lições de Notes

## Resumo

Uma lição de Notes percorre Aprender, Treinar e Sua vez no núcleo, com o currículo das casas 0–12. A etapa Aprender mostra o passo atual: notas da lição e de referência no braço, texto com notas e casas marcadas, Ouvir e Continuar. Sair pede confirmação e abandona a rodada sem salvar. As telas de pergunta, feedback e conclusão ainda não existem.

## Rotas/Telas

## 07 · Lição · Aprender

Tema escuro · Explicação 1 de 2 · pág. 9

![Lição · Aprender · Explicação 1 de 2 · tema escuro](../assets/design/licao-aprender-1de2-escuro.png)

**Objetivo**

- Primeira fase da lição ("Veja"): mostrar o truque no braço antes de qualquer pergunta.

**Elementos**

- Topo fixo: botão "✕" (44 px, sair) e barra de progresso da sessão (12 px) em 10%.
- Braço com janela de 6 casas (1 a 6), 6 cordas de 40 px com rótulos "e B G D A E": notas de referência "C" e "D" (círculo com contorno) e notas da lição "C♯" e "D♯" (círculo roxo) na corda A.
- Rótulo "Aprender · 1 de 2" (13 px, cinza).
- Título "Sustenido é uma casa acima" (28 px).
- Texto (16 px) com marca-texto nas notas e casas: "O C fica na casa 3. Suba uma casa e você chega no C♯, na casa 4." e "O mesmo vale para o D e o D♯, nas casas 5 e 6."
- Botão secundário "Ouvir" (ícone de alto-falante) e botão primário "Continuar".

**Estado e comportamento**

- O passo vem da lição: rótulo "Aprender · n de N", título, texto e posições. A imagem acima é a referência visual, não um texto fixo.
- Notas da lição são círculos preenchidos (`accent`); referências são círculos só com contorno. A janela mostra 6 casas cobrindo essas posições.
- A barra do topo mostra o passo atual sobre o total de passos de Aprender (1 de 2 preenche metade).
- "Ouvir" toca as notas destacadas, em ordem. Um novo Ouvir, Continuar ou Sair interrompe a sequência que ainda estiver tocando. Se o áudio falhar, a lição continua.
- "Continuar" avança para o próximo passo. No último, a fase passa a Treinar: a tela deixa de mostrar o passo e passa a indicar Treinar. As perguntas ficam fora desta tela.
- "✕" e o voltar do sistema abrem "Sair da sessão?" com "Esta rodada não será salva." Cancelar volta ao mesmo passo. Sair fecha a rodada sem salvar e sem concluí-la.

## 12 · Fim da lição

Tema escuro · 2 de 3 estrelas · pág. 16

![Fim da lição · 2 de 3 estrelas · tema escuro](../assets/design/fim-da-licao-2-estrelas-escuro.png)

**Objetivo**

- Celebrar a lição concluída e mostrar no braço as notas novas.

**Elementos**

- Rótulo "Novas no seu braço" e braço das casas 1 a 9 com as notas aprendidas em verde na corda A: "A♯", "C♯", "D♯", "F♯".
- Três estrelas de 48 px: duas preenchidas em amarelo, a terceira só com contorno tracejado.
- Título "Lição concluída" (32 px) e "90% de acerto de primeira" (16 px).
- Botão primário "Continuar" no rodapé.

**Estado e comportamento**

- Estrelas: 3 com 95% ou mais de acerto de primeira, 2 com 80% ou mais, 1 abaixo disso.
- No M2, "Continuar" volta à lista ou seletor de lições; integração com a sessão diária fica para M4.

## Estados

| Estado | Quando acontece | O que o usuário vê |
|---|---|---|
| Aprender | A sessão está na fase Aprender | Passo n de N, notas no braço, Ouvir e Continuar |
| Confirmação de saída | Toque em ✕ ou voltar do sistema | "Sair da sessão?" e "Esta rodada não será salva.", com Cancelar e Sair |
| Treinar iniciado | Continuar no último passo de Aprender | O passo some e a fase Treinar começa, ainda sem as perguntas |
| Rodada abandonada | Sair na confirmação | A lição fecha no mesmo passo, sem concluir e sem salvar |

## Ações

| Ação | Resultado |
|---|---|
| Ouvir | Reproduz, em ordem, as notas do passo e interrompe a sequência anterior |
| Continuar | Interrompe o som e avança o passo ou, no último, inicia Treinar |
| ✕ ou voltar do sistema | Abre a confirmação de saída |
| Cancelar | Fecha a confirmação e retoma o mesmo passo |
| Sair | Abandona a rodada sem salvar |

## 3. Fluxo de uma lição

```
LEARN (n passos) → PRACTICE (com apoio) → YOUR TURN (sem ajuda) → Lesson complete → seletor de lições (M2)
```
Em todas as telas: barra de progresso no topo e **X** para sair ✅

### 3.1 LEARN ✅
- O braço mostra só as notas-alvo, com a corda-alvo destacada.
- Cada passo ensina um **truque** diferente. Exemplos da lição "C, B, A na corda G":
  - *Shape da corda vizinha*: A, B, C da corda A (trastes 0, 2, 3) reaparecem na corda G nos trastes 2, 4, 5. Uma linha diagonal liga os dois.
  - *Contagem*: G solta → A (tom) → B (tom) → C (semitom).
- No texto, as notas e os trastes aparecem destacados com cor. Botão **Hear it** toca as notas. Botão **Continue**.

### 3.2 PRACTICE (com apoio) ✅
- **Notas de referência** (as já conhecidas) aparecem rotuladas nas outras cordas.
- Link **Hint** com o truque.
- **Name the note** tem só 4 opções.
- O acerto mostra a explicação completa.

### 3.3 YOUR TURN (prova) ✅
- Sem referência e sem Hint. Name the note tem 7 opções em lição só de naturais e 12 em lição com acidentes.
- Mistura perguntas de outras cordas já aprendidas.
- O acerto mostra um card curto. O erro mostra explicação + **Got it** (seção 4).
- **A posição errada volta mais tarde na mesma sessão** ✅ (aconteceu nas duas gravações).

### 3.4 Lesson complete ✅
- "New on your neck" (o braço com as notas novas), estrelas, "**90% right first time**" e o aviso de revisão.
- Estrelas: 3★ ≥ 95% · 2★ ≥ 80% · 1★ abaixo.

### 3.5 Session done — fora do M2
- 🔥 "N days · Streak kept".
- **Answered · First try % · Minutes**.
- "**Next up:** D, E and F on the G string".
- Botões: **Done**. Nos drills também aparece **Again**, que repete o mesmo drill.

## Currículo Notes 0–12 (afinação padrão)

18 lições em ordem sequencial, cobrindo as 6 cordas (0 = E grave até 5 = e aguda) e todas as 78 posições das casas 0–12 (naturais e sustenidos, 13 posições por corda):

| Ordem | ID | Corda | Tipo | Notas e casas |
|---|---|---|---|---|
| 1 | `notes-e-low-nat-1` | 0 (E grave) | Naturais | E (0), F (1), G (3), A (5) |
| 2 | `notes-e-low-nat-2` | 0 (E grave) | Naturais | B (7), C (8), D (10), E (12) |
| 3 | `notes-e-low-sharp` | 0 (E grave) | Sustenidos | F♯ (2), G♯ (4), A♯ (6), C♯ (9), D♯ (11) |
| 4 | `notes-a-nat-1` | 1 (A) | Naturais | A (0), B (2), C (3), D (5) |
| 5 | `notes-a-nat-2` | 1 (A) | Naturais | E (7), F (8), G (10), A (12) |
| 6 | `notes-a-sharp` | 1 (A) | Sustenidos | A♯ (1), C♯ (4), D♯ (6), F♯ (9), G♯ (11) |
| 7 | `notes-d-nat-1` | 2 (D) | Naturais | D (0), E (2), F (3), G (5) |
| 8 | `notes-d-nat-2` | 2 (D) | Naturais | A (7), B (9), C (10), D (12) |
| 9 | `notes-d-sharp` | 2 (D) | Sustenidos | D♯ (1), F♯ (4), G♯ (6), A♯ (8), C♯ (11) |
| 10 | `notes-g-nat-1` | 3 (G) | Naturais | G (0), A (2), B (4), C (5) |
| 11 | `notes-g-nat-2` | 3 (G) | Naturais | D (7), E (9), F (10), G (12) |
| 12 | `notes-g-sharp` | 3 (G) | Sustenidos | G♯ (1), A♯ (3), C♯ (6), D♯ (8), F♯ (11) |
| 13 | `notes-b-nat-1` | 4 (B) | Naturais | B (0), C (1), D (3), E (5) |
| 14 | `notes-b-nat-2` | 4 (B) | Naturais | F (6), G (8), A (10), B (12) |
| 15 | `notes-b-sharp` | 4 (B) | Sustenidos | C♯ (2), D♯ (4), F♯ (7), G♯ (9), A♯ (11) |
| 16 | `notes-e-high-nat-1` | 5 (e aguda) | Naturais | E (0), F (1), G (3), A (5) |
| 17 | `notes-e-high-nat-2` | 5 (e aguda) | Naturais | B (7), C (8), D (10), E (12) |
| 18 | `notes-e-high-sharp` | 5 (e aguda) | Sustenidos | F♯ (2), G♯ (4), A♯ (6), C♯ (9), D♯ (11) |

## Critérios de aceite vigentes

- **AC-F2-03:** Aprender apresenta os passos da lição e notas destacadas; Continuar avança entre passos e depois para Treinar; Ouvir reproduz as notas destacadas em sequência.
- **AC-F2-09:** O comando de saída durante a lição abre confirmação com Cancelar e Sair; Cancelar retorna à lição e Sair abandona a rodada sem salvar.
- **AC-F2-10:** Flutter tests verificam rótulos semânticos e ações dos controles de lição, incluindo saída e confirmação. Validação de acessibilidade na árvore do dispositivo não é exigida para M2.

## Critérios de aceite de planejamento — M2

AC-F2-03, AC-F2-09 e AC-F2-10 estão na seção vigente. Os demais seguem como planejamento.

- **AC-F2-01:** O currículo de Notes abrange as casas 0–12, corda por corda, com notas naturais e sustenidos. O detalhamento de cada lição será definido na issue do currículo.
- **AC-F2-02:** Uma lição percorre Aprender, Treinar e Sua vez, nessa ordem, e apresenta a conclusão após responder corretamente os alvos pendentes.
- **AC-F2-04:** Em Treinar aparecem referências e dica; Sua vez não apresenta referências nem dica. O acerto em Treinar traz explicação; em Sua vez, feedback curto.
- **AC-F2-05:** Uma resposta errada retorna ao fim da fila da mesma lição e continua sendo reapresentada após cada erro até ser respondida corretamente.
- **AC-F2-06:** Cada alvo conta uma vez no percentual de primeira tentativa: conta como acerto somente se sua primeira resposta na lição for correta; reapresentações não alteram essa contagem. O percentual é acertos de primeira divididos pelo total de alvos da lição, vezes 100.
- **AC-F2-07:** A conclusão apresenta as notas novas no braço, o percentual de acerto de primeira e três estrelas: 3 para percentual ≥ 95%, 2 para ≥ 80% e < 95%, 1 para < 80%.
- **AC-F2-08:** Na conclusão, Continuar volta à lista ou seletor de lições no M2; não abre Session done.

## Pendências

> Pendente: confirmar estados vazios, carregamento e erros aplicáveis.
