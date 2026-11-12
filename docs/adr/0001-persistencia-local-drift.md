# 0001. Persistência local com Drift e SQLite

- Status: Aceita
- Data: 2026-11-11
- Questão: Como persistir dados locais do MVP?

## Contexto

O aplicativo funciona offline e mantém progresso, configurações e treinos no dispositivo.

## Decisão

Usar Drift com SQLite para persistência local. Decisão confirmada na entrevista de preparo.

## Alternativas consideradas

Nenhuma alternativa foi avaliada nesta rodada.

## Consequências

O aplicativo precisa manter esquema e migrações locais; não há conta ou sincronização no MVP.
