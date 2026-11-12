# Design system — Fretboard Trainer · "Caderno neon"

Versão completa do design system: cores, tokens, tipografia, espaçamento, forma, efeitos, componentes, ícones, braço, movimento e acessibilidade. Valores estruturados em [tokens.json](tokens.json); telas nas specs de cada feature.

Imagens de referência (no zip anterior, pasta `imagens/`): `ds-01-sistema-escuro.png`, `ds-02-sistema-claro.png`, `ds-03-braco-escuro.png`, `ds-04-braco-claro.png`.

> **Revisão 2026-11-12 (polimento "unslop").** Rótulos de seção em caixa baixa, 13/400 e `muted`; tags neutras (`surface` + tinta); `target` no alvo do braço, streak e estrelas da lição; borda das opções em `ink`; borda de card igual a `line`; brilho reduzido; escala de espaço em passos de 4; Atkinson em 400, com exceções para texto forte e marca-texto; sem exclamação na interface. As pranchas de direção A–D no canvas são histórico e não seguem esta revisão.

## Sumário

1. Princípios
2. Cores (tokens por tema)
3. Tokens prontos para código (JSON e CSS)
4. Tipografia
5. Espaçamento e layout
6. Forma: raios, bordas, efeitos
7. Componentes
8. Ícones (com SVG)
9. Componente braço
10. Movimento, som e haptics
11. Acessibilidade
12. Escrita e notação

---

## 1. Princípios

1. **O braço é o protagonista.** Nada na tela compete visualmente com ele (cor, brilho, movimento).
2. **Cara de caderno, energia de jogo.** Fundo quadriculado, contorno grosso ("tinta") e sombra dura deslocada; cores vivas só para o que tem significado.
3. **Feedback nunca depende só de cor.** Acerto e erro mudam forma + ícone + texto.
4. **Dois temas de primeira classe.** Escuro é o padrão. Nenhum componente tem cor fixa: tudo sai dos tokens.
5. **Contraste AA mínimo** e alvos de toque de pelo menos 44 × 44.
6. **Uma cor viva por tela.** O amarelo (`target`) pertence ao alvo do braço (o "?"), ao streak e às estrelas da lição. O lilás (`accent`) marca a ação principal, a seleção e a barra de progresso. Rótulos, tags e bordas de card ficam neutros: a ênfase no chrome vem do contorno de tinta e da sombra dura, não de cor.

---

## 2. Cores

### 2.1 Base

| Token | Escuro | Claro | Uso |
|---|---|---|---|
| `color.bg` | `#0D0F1A` | `#FAFAFD` | Fundo da tela |
| `color.grid` | `#181C32` | `#E4E6F4` | Linhas do quadriculado do fundo |
| `color.surface` | `#171A2B` | `#FFFFFF` | Cards, botões secundários, tags, barras de navegação, inputs |
| `color.text` | `#EEF0FF` | `#16183A` | Texto principal |
| `color.muted` | `#9AA0C3` | `#555A80` | Texto secundário, rótulos de seção, rótulos de corda, números de casa, abas inativas |
| `color.line` | `#2A2E4A` | `#C9CCE6` | Divisórias, borda de chip não selecionado, borda de card |
| `color.ink` | `#EEF0FF` | `#16183A` | "Tinta": contornos de 2 px, sombra dura, pestana |
| `color.card-border` | `#2A2E4A` | `#C9CCE6` | Borda de card padrão (igual a `line`). Card em destaque usa `ink` |

### 2.2 Acento

| Token | Escuro | Claro | Uso |
|---|---|---|---|
| `color.accent` | `#B9A6FF` | `#5B3FE0` | Botão primário, seleção (chip, segmento, aba ativa), barra de progresso, links |
| `color.on-accent` | `#120A33` | `#FFFFFF` | Texto e ícone sobre `accent` |
| `color.pop` | `#B9A6FF` | `#5B3FE0` | Sombra dura colorida (opções de resposta, card em destaque) |
| `color.option-border` | `#EEF0FF` | `#16183A` | Borda dos botões de resposta (igual a `ink`) |

### 2.3 Braço

| Token | Escuro | Claro | Uso |
|---|---|---|---|
| `color.board` | `#121526` | `#FFFFFF` | Fundo das casas |
| `color.board-hi` | `#2A3370` | `#FFF3A6` | Corda-alvo destacada; marca-texto no texto; quadrado de ícone das linhas de lista |
| `color.fret` | `#5A6296` | `#16183A` | Trastes |
| `color.string` | `#AEB5DD` | `#16183A` | Cordas |
| `color.inlay` | `#2A3058` | `#D9DCF0` | Marcadores (dots) |

### 2.4 Semânticas

| Token | Escuro | Claro | Uso |
|---|---|---|---|
| `color.target` | `#FFD84D` | `#FFD84D` | Alvo "?" no braço; chama do streak; estrelas da lição |
| `color.on-target` | `#221A00` | `#221A00` | Texto sobre `target` |
| `color.ok` | `#5CF08A` | `#12A150` | Acerto; nota conhecida; tag "Feito" |
| `color.on-ok` | `#06210F` | `#06210F` | Texto sobre `ok` |
| `color.ok-soft` | `#12281F` | `#DFF7E8` | Fundo do painel de acerto e do card "Feito" |
| `color.err` | `#FF6B8B` | `#F0476E` | Erro (também usado como destrutivo) |
| `color.on-err` | `#33030F` | `#33030F` | Texto sobre `err` |
| `color.err-soft` | `#2B1420` | `#FFE1E8` | Fundo do painel de erro |
| `color.learn` | `#4DE2FF` | `#0E7FA8` | Nota aprendendo (só contorno e texto) |

### 2.5 Regras de uso

- Texto sobre fundo colorido usa sempre o par `on-*` correspondente.
- `target` (amarelo) é o mesmo nos dois temas: o texto sobre ele é sempre escuro.
- `target` é reservado ao alvo do braço, ao streak e às estrelas da lição. Tags ("~5 min", "Foco") e quadrados de ícone de lista são neutros (`surface` / `board-hi` + tinta).
- `accent` não é cor de texto de rótulo. Rótulos de seção usam `muted`.
- `ok`, `err` e `learn` ficam mais escuros no claro para manter contraste com o fundo branco.
- Não existe cor de "aviso" separada; não crie uma sem antes rever o sistema.

---

## 3. Tokens prontos para código

### 3.1 JSON

```json
{
  "color": {
    "escuro": {
      "bg": "#0D0F1A", "grid": "#181C32", "surface": "#171A2B",
      "text": "#EEF0FF", "muted": "#9AA0C3", "line": "#2A2E4A",
      "ink": "#EEF0FF", "cardBorder": "#2A2E4A",
      "accent": "#B9A6FF", "onAccent": "#120A33", "pop": "#B9A6FF", "optionBorder": "#EEF0FF",
      "board": "#121526", "boardHi": "#2A3370", "fret": "#5A6296", "string": "#AEB5DD", "inlay": "#2A3058",
      "target": "#FFD84D", "onTarget": "#221A00",
      "ok": "#5CF08A", "onOk": "#06210F", "okSoft": "#12281F",
      "err": "#FF6B8B", "onErr": "#33030F", "errSoft": "#2B1420",
      "learn": "#4DE2FF"
    },
    "claro": {
      "bg": "#FAFAFD", "grid": "#E4E6F4", "surface": "#FFFFFF",
      "text": "#16183A", "muted": "#555A80", "line": "#C9CCE6",
      "ink": "#16183A", "cardBorder": "#C9CCE6",
      "accent": "#5B3FE0", "onAccent": "#FFFFFF", "pop": "#5B3FE0", "optionBorder": "#16183A",
      "board": "#FFFFFF", "boardHi": "#FFF3A6", "fret": "#16183A", "string": "#16183A", "inlay": "#D9DCF0",
      "target": "#FFD84D", "onTarget": "#221A00",
      "ok": "#12A150", "onOk": "#06210F", "okSoft": "#DFF7E8",
      "err": "#F0476E", "onErr": "#33030F", "errSoft": "#FFE1E8",
      "learn": "#0E7FA8"
    }
  },
  "font": {
    "display": "Space Grotesk",
    "body": "Atkinson Hyperlegible"
  },
  "type": {
    "display":    { "family": "display", "size": 40, "weight": 700, "lineHeight": 1.1 },
    "titleXl":    { "family": "display", "size": 32, "weight": 700, "lineHeight": 1.15 },
    "titleLg":    { "family": "display", "size": 30, "weight": 700, "lineHeight": 1.15 },
    "title":      { "family": "display", "size": 28, "weight": 700, "lineHeight": 1.15 },
    "titleMd":    { "family": "display", "size": 24, "weight": 700, "lineHeight": 1.2 },
    "titleSm":    { "family": "display", "size": 22, "weight": 700, "lineHeight": 1.2 },
    "heading":    { "family": "display", "size": 20, "weight": 700, "lineHeight": 1.2 },
    "subheading": { "family": "display", "size": 18, "weight": 700, "lineHeight": 1.25 },
    "button":     { "family": "display", "size": 16, "weight": 700, "lineHeight": 1 },
    "noteOption": { "family": "display", "size": 22, "weight": 700, "lineHeight": 1 },
    "noteMarker": { "family": "display", "size": 13, "weight": 700, "lineHeight": 1 },
    "bodyLg":     { "family": "body", "size": 16, "weight": 400, "lineHeight": 1.5 },
    "body":       { "family": "body", "size": 15, "weight": 400, "lineHeight": 1.45 },
    "bodySm":     { "family": "body", "size": 14, "weight": 400, "lineHeight": 1.45 },
    "chip":       { "family": "body", "size": 14, "weight": 400, "lineHeight": 1 },
    "tag":        { "family": "body", "size": 13, "weight": 400, "lineHeight": 1 },
    "caption":    { "family": "body", "size": 13, "weight": 400, "lineHeight": 1.3 },
    "label":      { "family": "body", "size": 13, "weight": 400, "lineHeight": 1 },
    "tab":        { "family": "body", "size": 12, "weight": 400, "lineHeight": 1 }
  },
  "space": { "0": 2, "1": 4, "2": 8, "3": 12, "4": 16, "5": 20, "6": 24, "7": 28, "8": 32, "9": 40 },
  "radius": { "tag": 6, "control": 8, "feedbackBadge": 10, "card": 12, "switch": 16, "chip": 22, "full": 999 },
  "border": { "ink": 2, "nut": 6, "fret": 2 },
  "size": { "touchMin": 44, "button": 52, "option": 60, "chip": 44, "tag": 28, "infoChip": 32, "icon": 20, "iconSm": 16, "marker": 30, "stringRow": 40, "listRow": 56, "openStringCol": 44, "stringLabelCol": 26, "gridStep": 20 },
  "shadow": { "hard": "3 3 0 ink", "pop": "3 3 0 pop", "popLg": "4 4 0 pop" },
  "motion": { "maxMs": 250 },
  "breakpoint": { "expanded": 600 }
}
```

### 3.2 CSS (variáveis)

```css
:root, [data-theme="escuro"] {
  --bg:#0D0F1A; --grid:#181C32; --surface:#171A2B; --text:#EEF0FF; --muted:#9AA0C3; --line:#2A2E4A;
  --ink:#EEF0FF; --card-border:#2A2E4A;
  --accent:#B9A6FF; --on-accent:#120A33; --pop:#B9A6FF; --option-border:#EEF0FF;
  --board:#121526; --board-hi:#2A3370; --fret:#5A6296; --string:#AEB5DD; --inlay:#2A3058;
  --target:#FFD84D; --on-target:#221A00;
  --ok:#5CF08A; --on-ok:#06210F; --ok-soft:#12281F;
  --err:#FF6B8B; --on-err:#33030F; --err-soft:#2B1420;
  --learn:#4DE2FF;
  --glow-target:0 0 0 2px var(--ink), 0 0 12px rgba(255,216,77,.4);
  --glow-ok:0 0 12px rgba(92,240,138,.35);
}
[data-theme="claro"] {
  --bg:#FAFAFD; --grid:#E4E6F4; --surface:#FFFFFF; --text:#16183A; --muted:#555A80; --line:#C9CCE6;
  --ink:#16183A; --card-border:#C9CCE6;
  --accent:#5B3FE0; --on-accent:#FFFFFF; --pop:#5B3FE0; --option-border:#16183A;
  --board:#FFFFFF; --board-hi:#FFF3A6; --fret:#16183A; --string:#16183A; --inlay:#D9DCF0;
  --target:#FFD84D; --on-target:#221A00;
  --ok:#12A150; --on-ok:#06210F; --ok-soft:#DFF7E8;
  --err:#F0476E; --on-err:#33030F; --err-soft:#FFE1E8;
  --learn:#0E7FA8;
  --glow-target:0 0 0 2px var(--ink);
  --glow-ok:0 0 0 2px var(--ink);
}
:root {
  --font-display:'Space Grotesk','Trebuchet MS',sans-serif;
  --font-body:'Atkinson Hyperlegible',Verdana,sans-serif;
  --radius-tag:6px; --radius-control:8px; --radius-card:12px; --radius-chip:22px;
  --border-ink:2px;
  --shadow-hard:3px 3px 0 var(--ink);
  --shadow-pop:3px 3px 0 var(--pop);
  --shadow-pop-lg:4px 4px 0 var(--pop);
  --touch-min:44px;
}
.screen {
  font-family:var(--font-body);
  font-variant-numeric:tabular-nums;
  background-color:var(--bg);
  background-image:linear-gradient(var(--grid) 1px, transparent 1px), linear-gradient(90deg, var(--grid) 1px, transparent 1px);
  background-size:20px 20px;
}
```

---

## 4. Tipografia

### 4.1 Famílias

| Família | Pesos | Uso | Fallback |
|---|---|---|---|
| **Space Grotesk** | 700 | Títulos, nomes de nota, números grandes, botões, títulos de linha de lista | Trebuchet MS, sans-serif |
| **Atkinson Hyperlegible** | 400 | Texto corrido, rótulos de seção, chips, tags, abas, legendas, rótulos de corda e casa | Verdana, sans-serif |

As duas estão no Google Fonts (licença OFL). Nenhuma das duas tem os glifos ♯ e ♭: eles caem na fonte do sistema. Teste a altura e o alinhamento em cada plataforma.

A hierarquia vem de tamanho, família e cor, não de peso: o 700 é exclusivo da Space Grotesk. Atkinson fica em 400; as exceções são `<strong>` dentro de texto corrido (ex.: "42 de 78" no cabeçalho de Progresso em paisagem) e o marca-texto `.hl` no Aprender.

### 4.2 Escala

| Token | Família | Tam. / peso / altura | Onde aparece |
|---|---|---|---|
| `display` | Space Grotesk | 40 / 700 / 1.1 | "2 dias" no Fim da sessão |
| `titleXl` | Space Grotesk | 32 / 700 / 1.15 | "Lição concluída" |
| `titleLg` | Space Grotesk | 30 / 700 / 1.15 | Pergunta ("Que nota é essa?"), título de feedback ("Certo", "Quase") |
| `title` | Space Grotesk | 28 / 700 / 1.15 | Título de tela ("Hoje", "Praticar"), título da explicação em Aprender |
| `titleMd` | Space Grotesk | 24 / 700 / 1.2 | Título de tela com voltar ("Monte o seu"), números dos cards de Progresso |
| `titleSm` | Space Grotesk | 22 / 700 / 1.2 | Título do card da sessão |
| `heading` | Space Grotesk | 20 / 700 / 1.2 | "É um D♯" / "Você tocou D" |
| `subheading` | Space Grotesk | 18 / 700 / 1.25 | Título de card ("Notas"), "Próxima" |
| `button` | Space Grotesk | 16 / 700 | Botões, nomes de linha em listas |
| `noteOption` | Space Grotesk | 22 / 700 | Nome da nota nas opções de resposta |
| `noteMarker` | Space Grotesk | 13 / 700 | Nome da nota nos marcadores do braço |
| `bodyLg` | Atkinson | 16 / 400 / 1.5 | Explicações (feedback, Aprender) |
| `body` | Atkinson | 15 / 400 / 1.45 | Texto padrão, subtítulo de pergunta, link "Dica" |
| `bodySm` | Atkinson | 14 / 400 / 1.45 | Subtítulo do card da sessão, descrições curtas |
| `chip` | Atkinson | 14 / 400 | Chips de seleção, segmentado |
| `tag` | Atkinson | 13 / 400 | Tags ("~5 min", "Foco", "Feito"), chips informativos |
| `caption` | Atkinson | 13 / 400 | Descrições de linhas, legendas, detalhes, rótulos de corda |
| `label` | Atkinson | 13 / 400, caixa baixa (sentence case), cor `muted` | Rótulos de seção ("Treino", "Cordas", "Seu braço") |
| `tab` | Atkinson | 12 / 400 | Rótulos das abas, números de casa |

### 4.3 Regras

- Texto nunca abaixo de 12 px.
- Sem caixa alta com tracking em texto pequeno. Rótulos de seção são frases curtas em caixa baixa ("Treinar uma habilidade"), 13 px, `muted`.
- `letter-spacing` só em texto grande de exibição (ex.: a fila de glifos "C D E F G A B ♯ ♭" a 26 px na prancha do sistema). Nunca negativo abaixo de 40 px.
- Números em `tabular-nums`, um formato só por tela ("13 de 25 lições", "90% de acerto de primeira").
- Textos em PT-BR são cerca de 20–30% mais longos que em inglês: botões e chips crescem em largura e quebram linha no grupo, nunca truncam.
- Use `text-wrap: pretty` (ou equivalente) em títulos e parágrafos curtos.

---

## 5. Espaçamento e layout

### 5.1 Escala

Tudo em passos de 4. O 2 existe só como nudge interno (ícone + rótulo de aba, padding do switch). Um valor fora da escala é aceito só quando centraliza exatamente um controle: o botão ⋯ de 44 dentro da linha de lista de 56 leva padding vertical 6.

| Token | Valor | Uso típico |
|---|---|---|
| `space.0` | 2 px | Entre ícone e rótulo da aba; padding interno do switch |
| `space.1` | 4 px | Entre ícone e texto em tags; `margin-top` de botão dentro de card |
| `space.2` | 8 px | Entre chips; entre ✕ e barra de progresso; ícone + texto em chips, botões e links; entre rótulo de seção e seu bloco; entre itens de um painel de pergunta; padding vertical das linhas de lista (ícone de 40) |
| `space.3` | 12 px | Entre opções de 4 colunas; entre cards de uma lista; entre itens de um painel de feedback; padding horizontal de tags e chips informativos; margem lateral do painel (abas) em cima |
| `space.4` | 16 px | Entre opções 2 × 2; entre seções da Início; margem lateral das telas de aba; padding de card; padding horizontal de chips |
| `space.5` | 20 px | Margem lateral de painéis de pergunta e feedback; padding horizontal de botão; entre grupos em "Mais opções" |
| `space.6` | 24 px | Topo das telas de aba; padding superior do painel de feedback; entre grupos do Monte o seu |
| `space.7` | 28 px | Padding inferior dos painéis de pergunta |
| `space.8` | 32 px | Respiro grande (Fim da lição) |
| `space.9` | 40 px | Margem das pranchas de documentação; entre blocos da prancha do braço |

### 5.2 Layout

| Item | Valor |
|---|---|
| Breakpoint | < 600 dp = compacto (retrato); ≥ 600 dp = expandido (paisagem, tablet, desktop) |
| Referência compacta | 390 × 844 pt |
| Referência expandida | 844 × 390 pt |
| Margem lateral (abas) | 16 px |
| Margem lateral (pergunta, feedback) | 20 px |
| Barra de abas | 4 colunas iguais, padding 8 px em cima e 12 px embaixo |
| Rail lateral | 76 px de largura |
| Pergunta em paisagem | Braço 60% à esquerda, painel 40% à direita |
| Fundo quadriculado | Linha de 1 px `grid` a cada 20 px |

Agrupe irmãos com flex ou grid e `gap`; não use margens soltas entre elementos. Irmãos iguais têm o mesmo padding: todas as linhas de uma lista medem 56 de altura.

---

## 6. Forma, bordas e efeitos

### 6.1 Raios

| Token | Valor | Uso |
|---|---|---|
| `radius.tag` | 6 px | Tags, marcador da corda-alvo na legenda |
| `radius.control` | 8 px | Botões, opções, inputs, segmentado, quadrado de erro no braço, quadrado de ícone de lista |
| `radius.feedbackBadge` | 10 px | Selo ✕ do painel de erro |
| `radius.card` | 12 px | Cards |
| `radius.switch` | 16 px | Switch |
| `radius.chip` | 22 px | Chips (pílula) |
| `radius.full` | 50% | Marcadores do braço, bolinhas da semana, selo ✓ |

### 6.2 Bordas

| Uso | Espessura | Cor |
|---|---|---|
| Contorno "tinta" (botões, opções de resposta, inputs, segmentado, switch, barra de progresso, tags, borda da barra de abas) | 2 px | `ink` |
| Card | 2 px | `card-border` (= `line`) |
| Card em destaque | 2 px | `ink` |
| Chip não selecionado | 2 px | `line` (tracejada se desativado) |
| Divisória entre linhas de card | 2 px | `line` |
| Pestana | 6 px | `ink` |
| Trastes | 2 px | `fret` |

### 6.3 Efeitos

| Token | Escuro | Claro | Uso |
|---|---|---|---|
| `shadow.hard` | `3px 3px 0 ink` | igual | Botão primário |
| `shadow.pop` | `3px 3px 0 pop` | igual | Opções de resposta |
| `shadow.popLg` | `4px 4px 0 pop` | igual | Card da sessão, card Revisar, círculo do streak |
| `glow.target` | anel 2 px `ink` + `0 0 12px rgba(255,216,77,.4)` | só anel 2 px `ink` | Alvo "?" |
| `glow.ok` | `0 0 12px rgba(92,240,138,.35)` | anel 2 px `ink` | Acerto no braço |
| Seleção no mapa | anel 3 px `bg` + 5 px `ink` | igual | Posição selecionada no Progresso |

Brilho só existe no escuro e só no braço. Não há sombras suaves (blur) em nenhum outro lugar. A sombra dura deslocada é a assinatura do produto e a única fonte de ênfase fora do braço.

---

## 7. Componentes

Medidas em px. "Tinta" = borda 2 px `ink`.

### 7.1 Botões

| Variante | Altura | Fundo | Texto | Borda | Sombra | Exemplos |
|---|---|---|---|---|---|---|
| Primário | 52 | `accent` | `on-accent`, `button` | tinta | `shadow.hard` | "Começar sessão de hoje", "Continuar", "Entendi", "Concluir" |
| Secundário | 52 | `surface` | `text`, `button` | tinta | — | "Ouvir", "Salvar", "Continuar aprendendo" |
| Ícone | 44 × 44 | — | ícone 20 `text` | — | — | ✕, voltar, ⋯ |
| Link | ≥ 44 de altura | — | `accent`, `body` (15/400) | — | — | "Dica", "Aprender primeiro" |

- Padding horizontal 20; ícone opcional à esquerda com gap 8.
- Botão de rodapé ocupa a largura toda.
- Botão de ícone sempre tem rótulo de acessibilidade.

### 7.2 Opção de resposta (nota)

| Propriedade | Valor |
|---|---|
| Altura | 60 |
| Fundo | `surface` |
| Borda | 2 px `option-border` (= `ink`) |
| Sombra | `shadow.pop` |
| Raio | 8 |
| Texto | `noteOption` |
| Grade | 4 opções: 2 × 2, gap 16 · 7 opções: 4 colunas, gap 12 · 12 opções: 4 × 3, gap 12, ordem cromática |

Um toque = uma resposta, sem confirmação.

### 7.3 Chip de seleção

| Estado | Fundo | Texto | Borda |
|---|---|---|---|
| Normal | `surface` | `text` | 2 px `line` |
| Selecionado | `accent` | `on-accent` | 2 px `ink` |
| Desativado / "em breve" | `surface` | `muted` | 2 px `line` **tracejada** |

Altura mínima 44, largura mínima 48, padding 16, raio 22, texto `chip`. Gap 8 entre chips; o grupo quebra linha. No máximo dois chips "em breve" por grupo (os próximos da fila), não a lista inteira do roadmap.

### 7.4 Tag

Altura 28, padding 12, raio 6, tinta, fundo `surface`, texto `text` em `tag`. Ex.: "~5 min", "Foco". Variante "Feito": fundo `ok`, texto `on-ok`, ícone ✓ de 14 — é a única tag com cor, porque carrega estado.

### 7.5 Chip informativo

Não clicável. Altura 32, padding 12, raio 16, borda 2 px `line`, texto `tag` (13/400) `text`, ícone 16 com gap 8. Ex.: "8 para revisar", "1 lição nova".

### 7.6 Card

| Variante | Fundo | Borda | Sombra |
|---|---|---|---|
| Padrão | `surface` | 2 px `card-border` (= `line`) | — |
| Em destaque | `surface` | 2 px `ink` | `shadow.popLg` |
| Concluído | `ok-soft` | 2 px `card-border` | — |

Raio 12, padding 16 (12 vertical em cards compactos de número). Linhas de lista dentro de card: altura 56, divisória de 2 px `line`.

### 7.7 Linha de lista (drills)

Altura 56. Quadrado de ícone 40 × 40 (raio 8, tinta, fundo `board-hi`, inclusive no Revisar), título `button`, descrição `caption` `muted`, chevron ou botão ⋯ (44) à direita. Gap 12. Padding 8 12; quando a linha tem o botão ⋯ de 44, padding vertical 6 para fechar nos mesmos 56.

### 7.8 Controle segmentado

Tinta, raio 8, segmentos iguais com altura ≥ 44 e texto `chip`. Ativo: fundo `accent`, texto `on-accent`. Inativo: sem fundo, texto `text`.

### 7.9 Switch

52 × 32, tinta, raio 16, padding 2, bolinha 24. Desligado: fundo `surface`, bolinha `muted` à esquerda. Ligado: fundo `accent`, bolinha `ink` à direita.

### 7.10 Campo de texto

Altura 52, padding 12, fundo `surface`, tinta, raio 8, texto `bodyLg`. Rótulo em `label` acima. Mensagem de sucesso abaixo: ✓ `ok` + texto 14, sem ponto final. Mensagem de erro: ✕ `err` + texto 14, borda do campo em `err` [a confirmar: não desenhado].

### 7.11 Barra de progresso

Altura 12, tinta, raio 6, fundo `surface`, preenchimento `accent` sem raio interno. A da sessão fica no topo, ao lado do ✕, e avança a cada resposta.

### 7.12 Semana e streak

- Bolinhas de 36 com a inicial do dia (13/400). Praticado: fundo `accent`, texto `on-accent`, borda `ink`. Hoje não praticado: borda tracejada `ink`. Futuro: borda `line`, texto `muted`.
- Streak: ícone de chama 20 em `target` + número 18/700 Space Grotesk.
- Fim da sessão: círculo de 96 em `target`, tinta, `shadow.popLg`, chama de 52.

### 7.13 Estrelas (Fim da lição)

48 × 48. Ganha: preenchida `target`, traço 1,6 `ink`. Não ganha: sem preenchimento, traço `ink` tracejado (3 3).

### 7.14 Painel de feedback

Ocupa a parte de baixo da tela de pergunta, com borda superior de tinta. Padding 24 / 20 / 28, gap 12.

| | Acerto | Erro |
|---|---|---|
| Fundo | `ok-soft` | `err-soft` |
| Selo 44 × 44 | círculo `ok`, ✓ 24 em `on-ok`, tinta | quadrado raio 10 `err`, ✕ 24 em `on-err`, tinta |
| Título (`titleLg`) | varia, sem exclamação: "Certo", "Boa", "Isso aí", "Mandou bem" | "Quase" |
| Linha 2 (`heading`) | "É um D♯" | "Você tocou D" ou "É um A" (tempo esgotado) |
| Explicação (`bodyLg`) | só na fase Treinar | sempre |
| Botão primário | "Continuar" | "Entendi" |

### 7.15 Navegação

- **Barra inferior** (compacto): fundo `surface`, borda superior tinta, 4 abas, padding 8 em cima e 12 embaixo. Aba: altura ≥ 48, ícone 20 dentro de uma pílula de 52 × 28 + rótulo `tab` (12/400). Ativa: pílula `accent` com borda `ink`, rótulo `text`. Inativa: sem pílula, ícone e rótulo `muted`.
- **Rail lateral** (expandido): mesma aba empilhada, largura 76, borda direita tinta, abas com altura ≥ 56, gap 8.
- **Topo de lição/drill:** ✕ (44) + barra de progresso; sem barra de abas.

---

## 8. Ícones

### 8.1 Estilo

- Traço (stroke) de **2,2**, `stroke-linecap: round`, `stroke-linejoin: round`, sem preenchimento, salvo onde indicado.
- `viewBox="0 0 24 24"`, exibido em 20 px (16 em chips informativos, 14 em tags, 24 nos selos de feedback).
- Cor herdada do texto (`currentColor`).
- Ícones são desenhos simples feitos para este projeto; dá para trocar por um pacote de traço equivalente (ex.: Lucide) se mantiver espessura e pontas.

### 8.2 Lista com SVG

| Nome | Uso | SVG (conteúdo dentro de `<svg viewBox="0 0 24 24">`) |
|---|---|---|
| `close` | Sair da lição, fechar | `<path d="M6 6l12 12M18 6L6 18"/>` |
| `back` | Voltar | `<path d="M15 6l-6 6 6 6"/>` |
| `chevron-right` | Linha clicável | `<path d="M9 6l6 6-6 6"/>` |
| `chevron-up` | Recolher "Mais opções" | `<path d="M6 15l6-6 6 6"/>` |
| `play` | Começar | `<path d="M8 5v14l11-7z" fill="currentColor"/>` |
| `plus` | Lição nova, Continuar aprendendo | `<path d="M12 5v14M5 12h14"/>` |
| `review` | Revisar, "para revisar" | `<path d="M4 12a8 8 0 0 1 14-5l2 2M20 4v5h-5M20 12a8 8 0 0 1-14 5l-2-2M4 20v-5h5"/>` |
| `bolt` | Rodada rápida | `<path d="M13 3L5 14h6l-1 7 8-11h-6z"/>` |
| `grid` | Ache todas | `<path d="M4 4h7v7H4zM13 4h7v7h-7zM4 13h7v7H4zM13 13h7v7h-7z"/>` |
| `list` | Monte o seu, drills salvos | `<path d="M4 7h16M4 12h16M4 17h16"/>` |
| `more` | Menu ⋯ | `<circle cx="5" cy="12" r="1.5" fill="currentColor"/><circle cx="12" cy="12" r="1.5" fill="currentColor"/><circle cx="19" cy="12" r="1.5" fill="currentColor"/>` |
| `bulb` | Dica | `<path d="M9 18h6M10 21h4M12 3a6 6 0 0 0-3.5 10.9c.6.5 1 1.2 1 2.1h5c0-.9.4-1.6 1-2.1A6 6 0 0 0 12 3z"/>` |
| `speaker` | Ouvir | `<path d="M4 10v4h4l5 4V6L8 10zM16 9a4 4 0 0 1 0 6"/>` |
| `flame` | Streak | `<path d="M12 3c1 3 5 5 5 10a5 5 0 0 1-10 0c0-2 1-3 2-4 0 2 1 3 2 3 0-3 0-6 1-9z" fill="currentColor"/>` (preenchido, sem traço) |
| `check` | Acerto, Feito, salvo | `<path d="M5 12.5l4.5 4.5L19 7.5"/>` (traço 3 nos selos) |
| `star` | Estrelas da lição | `<path d="M12 3l2.7 5.6 6.1.8-4.5 4.3 1.1 6.1L12 17l-5.4 2.8 1.1-6.1L3.2 9.4l6.1-.8z"/>` (traço 1,6) |
| `tab-home` | Aba Início | `<path d="M4 11l8-7 8 7v9h-5v-6H9v6H4z"/>` |
| `tab-practice` | Aba Praticar | `<circle cx="12" cy="12" r="8"/><circle cx="12" cy="12" r="3"/>` |
| `tab-progress` | Aba Progresso | `<path d="M5 20V10M12 20V4M19 20v-7"/>` |
| `tab-settings` | Aba Ajustes | `<path d="M4 7h10M18 7h2M4 17h2M10 17h10"/><circle cx="16" cy="7" r="2"/><circle cx="8" cy="17" r="2"/>` |

Exemplo completo:

```html
<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor"
     stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
  <path d="M6 6l12 12M18 6L6 18"/>
</svg>
```

Ícones de decoração levam `aria-hidden`; botões só com ícone levam rótulo de acessibilidade.

---

## 9. Componente braço

### 9.1 Anatomia

| Parte | Especificação |
|---|---|
| Cordas | 6, de cima para baixo: e · B · G · D · A · E (E grave embaixo) |
| Altura de cada corda (linha) | 40 |
| Espessura das cordas | e, B = 1 · G, D = 2 · A, E = 3 (cor `string`) |
| Coluna de rótulos | 26 à esquerda, `muted` 13/400 |
| Coluna de corda solta | 44, antes da pestana, sem fundo, tocável |
| Pestana | 6 px `ink` |
| Trastes | 2 px `fret`; fundo das casas `board` |
| Números das casas | Embaixo, `tab` `muted`, padding superior 8 |
| Marcadores | Círculo 12 `inlay`, na linha entre G e D, nas casas 3, 5, 7, 9, 15, 17, 19, 21; duplo na 12 (entre B/G e entre D/A) |
| Casas existentes | 0–22 (21 ou 24 conforme Ajustes); desenho padrão até a 15 |

### 9.2 Estados de uma posição

Marcadores de 30 com o nome da nota em `noteMarker`.

| Estado | Visual | Onde |
|---|---|---|
| Vazia | nada | padrão |
| Alvo "?" | círculo `target`, "?" `on-target`, `glow.target` | "Que nota é essa?" |
| Corda-alvo | a corda inteira com fundo `board-hi` | "Ache o C♯ na corda A", erro |
| Referência | círculo `board`, borda 2 `ink`, texto `text` | notas de apoio em Treinar e Aprender |
| Nota da lição | círculo `accent`, borda 2 `ink`, texto `on-accent` | Aprender |
| Acerto | círculo `ok`, `glow.ok`; a corda fica `ok` com 4 px da pestana até a nota | depois de acertar |
| Erro | quadrado raio 8 `err`, texto `on-err` com a nota tocada | depois de errar |
| Revelada | círculo `board`, borda 2 **tracejada** `ink` | resposta certa depois do erro, "Mostrar" |
| Conhecida | círculo preenchido `ok` | mapa de progresso |
| Aprendendo | círculo `board`, contorno 2,5 `learn`, texto `learn` | mapa de progresso |
| Selecionada | anel 3 `bg` + 5 `ink` em volta do marcador | posição tocada no mapa |
| Hover (desktop) | célula com `board-hi` em opacidade reduzida | casa sob o cursor |

### 9.3 Comportamentos

- **Janela dinâmica:** em perguntas, 6 casas em volta do alvo; em 390 de largura cada casa fica com ~56 (mínimo 44). Desliza entre perguntas em até 250 ms.
- **Sempre horizontal**, nas duas orientações.
- **Canhoto:** espelha só na horizontal (pestana e rótulos à direita, números invertidos); a ordem das cordas não muda; a linha de acerto parte da pestana à direita.
- **Toque:** a área tocável é a célula inteira (casa × corda), não só o marcador.
- **Mapa de progresso:** sem janela dinâmica; 0–12 ou braço todo. Em retrato rola na horizontal (largura 650 para 0–12); em paisagem cabe inteiro.
- **Desktop:** só mouse (hover). Sem atalhos de teclado por enquanto.

---

## 10. Movimento, som e haptics

| Item | Regra |
|---|---|
| Duração | Até 250 ms, na troca de pergunta e no deslize da janela do braço |
| Bloqueio | Nenhuma animação atrasa a próxima pergunta |
| Haptic de acerto | Leve, um pulso |
| Haptic de erro | Duplo |
| Som | A nota tocada soa ao responder, se "Sons" estiver ligado; "Ouvir" toca as notas da explicação em sequência |
| Ritmo | Feedback sempre espera o toque em Continuar/Entendi |

---

## 11. Acessibilidade

- Texto com contraste ≥ 4,5:1 (3:1 a partir de 24 px) nos dois temas.
- Alvos de toque ≥ 44 × 44 em tudo: opções, chips, abas, células do braço, botões de ícone.
- Acerto/erro com forma + ícone + texto. Aprendendo vs. conhecida pelo preenchimento, não só pela cor.
- Botões de ícone com rótulo ("Sair da lição", "Opções de <drill>").
- Barra de progresso exposta como progresso, com valor atual e máximo.
- Painel de feedback anunciado ao leitor de tela quando aparece.
- Grupos de chips e segmentados expõem o estado selecionado (pressionado/marcado).
- Mapa do braço rolável com foco e rótulo ("Mapa do braço, role para o lado").

---

## 12. Escrita e notação

- Interface em português e inglês no MVP, conforme decisões da entrevista.
- Notas: C D E F G A B, com ♯ (U+266F) e ♭ (U+266D) tipográficos, nunca "#" ou "b". Sustenidos ou bemóis conforme Ajustes.
- Tom curto e direto, segunda pessoa ("Você tocou D", "Toque no braço").
- Sem exclamação em texto de interface. Títulos de acerto variam ("Certo", "Boa", "Isso aí", "Mandou bem"); o de erro é sempre "Quase" (nunca "Errado").
- Títulos, subtítulos, rótulos, botões, tags e linhas de estado não terminam em ponto ("É um D♯", "Lição concluída", "Salvo nos seus drills"). Só parágrafos de explicação levam ponto.
- O título de uma tela nomeia o contexto, não cumprimenta: a Início abre com "Hoje" e a saudação ("Boa tarde · terça-feira") fica em `body` `muted` acima. Nada de "Pronto para praticar?" como título.
- Rótulos de seção em caixa baixa: "Treinar uma habilidade", "Seus drills", "Seu braço".
- Números: "13 de 25 lições", "90% de acerto de primeira", horários em 24 h ("19:00").
- Sem emoji na interface; ícones de traço no lugar.

## Decisões da entrevista

- Telas Must ainda sem mockup podem seguir este design system.
- Fonte de fallback para símbolos musicais fica para o spike; priorizar suporte ao símbolo ♯, como em F♯.
- Temas Escuro, Claro e Seguir o sistema; idiomas português e inglês no MVP.
