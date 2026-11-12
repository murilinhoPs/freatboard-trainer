---
feature: F5
area: pendente
updated: 2026-11-11
---

# F5 · Sessão do dia

## Resumo

> Pendente: confirmar comportamento vigente; material descreve produto proposto.

## Rotas/Telas

## 01 · Início

Tema escuro · Sessão pendente · pág. 2

![Início · Sessão pendente · tema escuro](../assets/design/inicio-pendente-escuro.png)

**Objetivo**

- Ponto de entrada do app: mostrar a semana e o streak e levar direto à sessão do dia.

**Elementos**

- Saudação "Boa tarde · terça-feira" (15 px, texto secundário) e título "Hoje" (28 px).
- Card da semana: 7 bolinhas de 36 px com "S T Q Q S S D"; à direita, ícone de chama amarelo e o número do streak "1".
- Card da sessão do dia, em destaque (contorno de 2 px e sombra roxa de 4 px): tag neutra "~5 min" (28 px de altura, fundo de superfície e contorno de tinta); título "Sustenidos na corda A" (22 px); subtítulo "Notas · Os espaços entre as notas da corda A" (14 px); chips informativos "8 para revisar" (ícone de revisar) e "1 lição nova" (ícone +), 32 px de altura; botão primário "Começar sessão de hoje" com ícone play, 52 px de altura, largura total.
- Rótulo de seção "Treinar uma habilidade" (13 px, cinza).
- Card "Notas" com tag neutra "Foco", barra de progresso de 12 px preenchida em 52% e "13 de 25 lições".
- Dois chips desativados, com borda tracejada: "Intervalos · em breve" e "Tríades · em breve" (44 px). Só as duas próximas habilidades da fila aparecem.
- Barra de abas inferior: "Início" (ativa), "Praticar", "Progresso", "Ajustes".

**Estado e comportamento**

- Hoje é terça e ainda não houve prática: a bolinha "S" está preenchida em acento e a "T" tem contorno tracejado. Streak de 1 dia.
- A tag "~5 min" segue Ajustes → Tamanho da sessão.
- Os chips "8 para revisar" e "1 lição nova" somem quando o número é 0.
- "Começar sessão de hoje" abre a sessão: primeiro as revisões (formato de 10), depois a lição nova (07).
- Os chips "em breve" não respondem ao toque. As abas levam a 03, 05 e 06.

## 02 · Início

Tema escuro · Sessão concluída · pág. 3

![Início · Sessão concluída · tema escuro](../assets/design/inicio-concluido-escuro.png)

**Objetivo**

- Mostrar que a sessão do dia já foi feita e oferecer continuar aprendendo.

**Elementos**

- Mesmo topo de 01; na semana, "S" e "T" preenchidas e streak "2".
- Card da sessão em estado concluído: fundo verde-escuro (`#12281F`), tag verde "Feito" com ícone ✓ (a única tag com cor, porque indica estado), título "Tudo certo por hoje" (22 px), texto "Seu streak está garantido. Volte amanhã para revisar e aprender a próxima lição." e botão secundário "Continuar aprendendo" com ícone +.
- Card "Notas" com barra em 56% e "14 de 25 lições"; chips "em breve" e barra de abas iguais a 01.

**Estado e comportamento**

- Aparece depois de 13 Fim da sessão → "Concluir".
- "Continuar aprendendo" abre a próxima lição (07) fora da sessão diária.

## 13 · Fim da sessão

Tema escuro · Streak mantido · pág. 17

![Fim da sessão · Streak mantido · tema escuro](../assets/design/fim-da-sessao-streak-escuro.png)

**Objetivo**

- Resumir a sessão do dia e mostrar o que vem amanhã.

**Elementos**

- Círculo amarelo de 96 px com chama, contorno de 2 px e sombra roxa.
- Título "2 dias" (40 px) e "Streak mantido" (16 px).
- Card "Próxima" · "D, E e F na corda G".
- Três cards de números: "24" · "Respondidas", "88%" · "De primeira", "5" · "Minutos".
- Botão primário "Concluir" no rodapé.

**Estado e comportamento**

- "Concluir" leva a 02.
- Ao terminar um drill aparece também o botão "De novo", que refaz o mesmo drill [a confirmar: variante não desenhada].

## Estados e ações

## 2. Home

| Elemento | Detalhe |
|---|---|
| Saudação | "Good afternoon / Ready to practice?" ✅ |
| Semana | 7 bolinhas (S T Q Q S S D); o dia praticado fica preenchido ✅ |
| Streak | 🔥 + número de dias seguidos ✅ |
| **Card "Today's Session"** | Dois estados ✅ (ver abaixo) |
| **Train a skill** | Um card por habilidade, com barra de progresso e "X of N lessons". A habilidade atual leva o badge **Focus** ✅ |
| How it works | Tour de 4 slides ✅ (seção 9) |

### 2.1 Card "Today's Session" ✅

| | **Pendente** | **Concluído** |
|---|---|---|
| Badge | ⏱ **~5 min** (duração estimada) | ✓ Done |
| Título | Nome da próxima lição: "**Sharps on the A string**" | "All done for today" |
| Subtítulo | Habilidade + descrição: "Notes · The gaps between the A string's notes" | "Your streak is safe. Come back tomorrow and your notes will be ready to review." |
| Chips | **↻ 8 to review** · **+ 1 new lesson** | — |
| Botão | **▶ Start today's session** | **+ Keep learning** (próxima lição, fora da sessão) |

- A sessão do dia é **revisões vencidas + 1 lição nova**, nessa ordem (o tour diz "review, then your next lesson").
- O tamanho da sessão é configurável (**2, 5 ou 10 min**) e limita quantas revisões entram (teto de 20). ⚠️ Estimativa: `nº de revisões × ~8s + duração média de uma lição`.
- ⚠️ Sem revisões pendentes, o chip "to review" some e a sessão vira só a lição nova.
- O print confirma que **os sustenidos entram no currículo por corda** ("Sharps on the A string", na lição ~20 de 25), depois das naturais.

## Critérios de aceite vigentes

Nenhum comportamento implementado confirmado.

## Pendências

> Pendente: confirmar estados vazios, carregamento e erros aplicáveis.

## Decisões da entrevista — estados

Quando todas as lições estiverem concluídas e não houver revisões pendentes, oferecer prática livre ou revisão, dando destaque à revisão.

## Decisões da entrevista — rodada 3

Enquanto dados locais carregam, mostrar shimmer de carregamento.
