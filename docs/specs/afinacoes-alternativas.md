---
feature: F11
area: pendente
updated: 2026-11-11
---

# F11 · Afinações alternativas

## Resumo

> Pendente: confirmar comportamento vigente; material descreve produto proposto.

## Rotas/Telas

### 2.4 Monte o seu

![Monte o seu](../assets/design/monte-o-seu-mais-opcoes-aberto-escuro.png)

**O que é:** formulário para criar um drill personalizado. Tela com rolagem; o botão **▶ Começar** fica fixo no rodapé.

**Como funciona:**
- **Tipo:** Notas · Ache todas (outras "em breve"). Embaixo, descrição do tipo e o link **Aprender primeiro** (abre a lição correspondente).
- **Cordas:** E A D G B e — seleção **múltipla** (pelo menos uma).
- **Notas:** Naturais / Sustenidos.
- **Casas:** 0–5 · **0–12** (padrão) · 5–12 · 12–17 · 12–22 · Braço todo — seleção única.
- **Quantidade:** 10 · **20** · 40.
- **Mais opções** (card recolhível; fechado mostra o resumo "Padrão · 3 s"; o screenshot mostra aberto):
  - Afinação: Padrão, Drop D, Meio tom abaixo, DADGAD, Open G.
  - Direção: As duas, Achar a nota, Nomear a nota.
  - Tempo: Sem tempo, 2 s, **3 s**, 5 s.
- **Salvar como:** campo + botão **Salvar**.
  - Sucesso (desenhado): "✓ Salvo nos seus drills." O drill aparece em Praticar → Seus drills.
  - Erro (não desenhado): "Dê um nome ao drill primeiro." com o campo em destaque de erro.
- **▶ Começar** usa as opções atuais, salvo ou não.

## Estados e ações

## 12. Escopo v0.1

1. Currículo de Notes, fase 1 (0–12)
2. Motor de lição LEARN → PRACTICE → YOUR TURN, com fila de reapresentação dos erros
3. Os 4 tipos de pergunta + explicações geradas (contagem, oitava, dots)
4. SRS por posição (1d → 3d → 7d → 30d) + Review
5. Sessão diária + streak
6. Progress (mapa + chips + filtro)
7. Build your own completo (More options com Direction e Timer) + drills salvos + Speed round como drill predefinido
8. Settings: sustenidos/bemóis, canhoto, sons, trastes
9. Layout responsivo retrato + paisagem
10. **Etapa final do MVP: afinações alternativas na prática de notas.** Drop D · Half step down · DADGAD · Open G, opção *Tuning* em More options. Vale **só para Notes**.
    - A afinação vale para drills, Speed round e Find every. Lições e SRS continuam em Standard.
    - Prática em outras afinações **não conta para o progresso**.
    - Custo técnico baixo: `noteAt()` já recebe `Tuning`. O trabalho está em UI, explicações (o truque da oitava muda em DADGAD e Open G) e testes.

**v0.2:** Find every, fase 2 do currículo, lembretes diários, tour.

## Critérios de aceite vigentes

Nenhum comportamento implementado confirmado.

## Pendências

> Pendente: confirmar estados vazios, carregamento e erros aplicáveis.
