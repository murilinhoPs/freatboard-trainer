# Spike de fontes musicais

Space Grotesk (títulos, peso 700) e Atkinson Hyperlegible (corpo, peso 400) são assets locais sob SIL Open Font License; licenças acompanham os arquivos. Noto Music, também OFL e local, é o fallback explícito para ambas as famílias, sem depender de rede ou de fontes instaladas.

Avaliação em macOS via CoreText: Space Grotesk e Atkinson não possuem U+266F (♯) nem U+266D (♭); Noto Music contém ambos. A tela do spike exibe exemplos nas duas famílias e nos dois temas para avaliar altura e alinhamento. Validação visual no Android e Linux permanece necessária no QA do spike; cobertura de glifos não prova alinhamento nessas plataformas.

Origem: [Google Fonts](https://github.com/google/fonts), diretórios `ofl/spacegrotesk`, `ofl/atkinsonhyperlegible` e `ofl/notomusic`. Arquivos e licenças estão em `app/assets/fonts/`.
