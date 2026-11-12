---
feature: F7
area: pendente
updated: 2026-11-11
---

# F7 · Build your own

## Resumo

> Pendente: confirmar comportamento vigente; material descreve produto proposto.

## Rotas/Telas

## 04 · Monte o seu

Tema escuro · "Mais opções" aberto, drill salvo · pág. 5

![Monte o seu · "Mais opções" aberto, drill salvo · tema escuro](../assets/design/monte-o-seu-mais-opcoes-aberto-escuro.png)

A tela rola; a imagem mostra a tela inteira.

**Objetivo**

- Criar um drill personalizado escolhendo cordas, notas, casas, quantidade e opções avançadas.

**Elementos**

- Topo: botão voltar (44 px) e título "Monte o seu" (24 px). A tela rola; a imagem mostra a tela inteira em duas partes.
- "Tipo": chips "Notas" (selecionado), "Ache todas" e "Intervalos · em breve" (desativado); texto "Ache a nota no braço ou diga o nome da nota marcada." e link "Aprender primeiro".
- "Cordas": chips "E", "A", "D" (selecionados), "G", "B", "e" — seleção múltipla.
- "Notas": "Naturais" (selecionado), "Sustenidos".
- "Casas": "0–5", "0–12" (selecionado), "5–12", "12–17", "12–22", "Braço todo".
- "Quantidade": "10", "20" (selecionado), "40".
- Card "Mais opções", aberto, com resumo "Padrão · 3 s" e chevron: "Afinação" (Padrão selecionado, Drop D, Meio tom abaixo, DADGAD, Open G); "Direção" (As duas selecionado, Achar a nota, Nomear a nota); "Tempo" (Sem tempo, 2 s, 3 s selecionado, 5 s).
- "Salvar como": campo de texto (52 px) com "Cordas graves até a 12" e botão secundário "Salvar"; abaixo, mensagem de sucesso com ✓ verde "Salvo nos seus drills".
- Rodapé fixo com botão primário "Começar" (ícone play, largura total).

**Estado e comportamento**

- Chips selecionados ficam em acento com contorno; os demais em superfície com borda clara.
- Cordas aceitam várias escolhas (pelo menos uma); os outros grupos aceitam uma.
- "Mais opções" recolhe e expande; fechado mostra só o resumo "Padrão · 3 s".
- "Salvar" com nome adiciona o drill em 03 → Seus drills e mostra "Salvo nos seus drills". Sem nome, mostra "Dê um nome ao drill primeiro" [a confirmar: estado de erro não desenhado].
- "Começar" inicia o drill com as opções atuais, salvo ou não. "Aprender primeiro" abre a lição correspondente (07).

## Estados e ações

## 6. Build your own ✅

Na lateral fica a habilidade (Notes · Intervals · Triads · Scales · Find every). Cada uma tem uma descrição de uma linha e um link **Learn it first**.

| Opção | Valores no exemplo | Nosso app (22 trastes) |
|---|---|---|
| Strings | E A D G B e (liga/desliga cada uma) | igual |
| Notes | Naturals / Sharps | igual |
| Frets | 0–5 · **0–12** · 0–15 · 5–12 · 12–15 | 0–5 · **0–12** · 5–12 · 12–17 · 12–22 · **Braço todo (0–22)** |
| Length | 10 · **20** · 40 | igual |
| **More options ▾** | resumo: "Standard · 3s timer" | igual |
| ↳ Tuning | **Standard** · Drop D · Half step down · DADGAD · Open G | igual |
| ↳ Direction | **Both** · Find the note · Name the note | igual |
| ↳ Timer | No timer · 2s · **3s** · 5s | igual |
| Save as | Campo de nome + **Save** | igual |
| Ação | **Start** (topo) | igual |

- Salvar sem nome mostra o erro "*Give the drill a name first.*" Com sucesso: "*Saved to your drills.*" ✅
- **Start** abre a mesma tela de intro do Speed round, com os valores escolhidos ("20 questions, 5 seconds each") ✅. Ou seja, o **Speed round é só um drill predefinido** (todas as cordas, 0–12, 20 perguntas, 3s).
- **Padrão de Frets = 0–12** em todo drill novo. Faixas acima do 12 são opt-in.
- **Find every**: Length 5 · 10 · 20, e More options só "Standard" (sem timer).

## Critérios de aceite vigentes

Nenhum comportamento implementado confirmado.

## Pendências

> Pendente: confirmar estados vazios, carregamento e erros aplicáveis.
