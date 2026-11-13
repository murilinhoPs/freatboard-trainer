# Evidências do spike M0

Registro para o fechamento; não constitui decisão de go/no-go.

## Áudio

O protótipo carrega em memória `app/assets/audio/pluck-a2.wav` antes de aceitar reprodução. A amostra foi gerada para este spike por síntese matemática (senoides de 110 e 220 Hz com decaimento exponencial), sem gravação ou material de terceiros. Todas as células tocam a mesma nota A2: serve para avaliar latência, não para validar alturas do braço nem timbre de guitarra. `flutter_soloud` é usado apenas no protótipo.

Fonte candidata para guitarra real: [FreePats FSBS Electric Guitar Clean #1](https://freepats.zenvoid.org/ElectricGuitar/clean-electric-guitar.html), gravações de guitarra processadas, disponibilizadas pelo projeto sob [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/). A versão pequena contém amostras espaçadas; cobertura de E2 a D6, qualidade e eventual geração das notas intermediárias ainda precisam ser verificadas. Nenhuma amostra FreePats foi incorporada ao app.

| Plataforma | Reprodução e latência |
|---|---|
| Android | Inconclusivo: nenhum dispositivo Android disponível nesta execução. |
| Linux | Inconclusivo: host macOS, sem dispositivo Linux disponível nesta execução. |
| macOS | Build debug e abertura do braço confirmados em macOS 26.7.2 (Apple Silicon); interface indicou amostra carregada. Reprodução audível e latência não avaliadas. |

Para avaliar: abrir o braço, aguardar carregamento, tocar células repetidamente e registrar dispositivo, saída de áudio e percepção da resposta. Usar alto-falante ou fones com fio; Bluetooth acrescenta latência. Comparar com e sem som e registrar se atraso é perceptível. Sem avaliação humana, não declarar latência imperceptível.

## Interação, fontes e execução

- Testes de widget cobrem seleção nas bordas, janela, orientação e espelhamento; não comprovam precisão de toque humano em celular pequeno.
- [Spike de fontes](spike-fontes.md): cobertura de ♯/♭ verificada via CoreText no macOS; alinhamento avaliado em simulador iOS. Verificação visual em Android e Linux pendente.
- Android e Linux: execução e interação pendentes por indisponibilidade de dispositivos. macOS: app abriu e braço exibiu amostra carregada; interação e som não foram avaliados por uma pessoa. Não inferir funcionamento nessas plataformas a partir dos testes de widget.
- Critério de saída do M0 permanece inconclusivo até avaliação de toque e áudio nos dispositivos exigidos, ou decisão explícita no fechamento sobre essas limitações.
