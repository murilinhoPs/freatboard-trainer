---
feature: F10
area: pendente
updated: 2026-11-11
---

# F10 · Settings

## Resumo

> Pendente: confirmar comportamento vigente; material descreve produto proposto.

## Rotas/Telas

## 06 · Ajustes

Tema escuro · Padrão · pág. 8

![Ajustes · Padrão · tema escuro](../assets/design/ajustes-padrao-escuro.png)

A tela rola; a imagem mostra a tela inteira.

**Objetivo**

- Ajustar preferências do instrumento, da sessão, dos lembretes e do idioma.

**Elementos**

- Título "Ajustes" (28 px). A tela rola; a imagem mostra a tela inteira em duas partes.
- "Preferências" (card com linhas de 56 px): "Instrumento" · "Guitarra" com chevron; "Casas" com segmentado "21 / 22 / 24" (22 ativo); "Nomes das notas" com segmentado "Sustenidos F♯ / Bemóis G♭" (Sustenidos ativo); "Sons" com switch ligado; "Canhoto" com switch desligado.
- "Sessão": "Tamanho da sessão" com segmentado "2 min / 5 min / 10 min" (5 min ativo).
- "Lembretes": "Lembrete diário" com switch ligado; "Horário" · "19:00" com chevron.
- "Idioma": segmentado "Português / English" (Português ativo).
- Barra de abas com "Ajustes" ativa.

**Estado e comportamento**

- Tudo salva na hora, sem botão de salvar.
- "Instrumento" e "Horário" abrem seletores [a confirmar: seletores não desenhados].
- "Canhoto" espelha o braço em todas as telas. "Nomes das notas" muda a grafia em todo o app. "Tamanho da sessão" muda a tag de 01.
- Lembretes são P1.

## Estados e ações

## 8. Settings ✅

- Instrument (Guitar) · Note names (Sharps F♯ / Flats B♭) · Sounds · **Left-handed** (espelha o braço)
- Daily reminder · Reminder time · Notification settings
- ➕ **Nosso**: Trastes do instrumento (padrão **22**; opções 21/22/24) · Tamanho da sessão (**2 / 5 / 10 min**) · Idioma (PT-BR / English)

## Critérios de aceite vigentes

Nenhum comportamento implementado confirmado.

## Pendências

> Pendente: confirmar estados vazios, carregamento e erros aplicáveis.

## Decisões da entrevista

- Oferecer temas Escuro, Claro e Seguir o sistema.
- Disponibilizar português e inglês com internacionalização. Definir na implementação se o idioma será selecionável ou seguirá o sistema, conforme a opção mais simples na stack.

## Decisões da entrevista — estados

Se ajustes não puderem ser salvos, mostrar erro e permitir tentar novamente. Verificar possível falta de permissão do usuário ou do sistema.

## Decisões da entrevista — rodada 3

Progresso, configurações e treinos salvos ficam localmente no dispositivo, sem conta ou sincronização no MVP.
