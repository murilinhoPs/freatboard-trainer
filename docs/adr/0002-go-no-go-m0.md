# 0002. Avançar ao M1 com validações de áudio pendentes

- Status: Aceita
- Data: 2026-11-13
- Questão: O M0 pode avançar sem os testes de áudio e latência em Android e Linux?

## Contexto

O M0 avaliou o protótipo e a interação do braço. Os testes de áudio e latência em Android e Linux não foram realizados.

## Decisão

Go para M1, ciente das validações pendentes. Não criar issue para esses testes.

## Alternativas consideradas

- Bloquear o M1 até completar os testes — não escolhido pelo usuário.

## Consequências

O trabalho de M1 pode começar. Compatibilidade e latência de áudio em Android e Linux permanecem sem validação; o app deve continuar utilizável quando o áudio estiver indisponível.
