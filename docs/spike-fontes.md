# Spike de fontes musicais

Space Grotesk (títulos, peso 700) e Atkinson Hyperlegible (corpo, peso 400) são assets locais sob SIL Open Font License; licenças acompanham os arquivos. Noto Music, também OFL e local, é o fallback explícito para ambas as famílias, sem depender de rede ou de fontes instaladas.

Avaliação em macOS via CoreText: Space Grotesk e Atkinson não possuem U+266F (♯) nem U+266D (♭); Noto Music contém ambos. A tela do spike exibe exemplos nas duas famílias e nos dois temas para avaliar altura e alinhamento. Validação visual no Android e Linux permanece necessária no QA do spike; cobertura de glifos não prova alinhamento nessas plataformas.

Origem: [Google Fonts](https://github.com/google/fonts), diretórios `ofl/spacegrotesk`, `ofl/atkinsonhyperlegible` e `ofl/notomusic`. Arquivos e licenças estão em `app/assets/fonts/`.

**Superado pela #11:** o spike inicial elevava ♯ e ♭ em 16% do tamanho da fonte; esse ajuste único foi substituído pelo ajuste por glifo e por família efetiva (o corpo herda Atkinson do tema) descrito em "Alinhamento vertical de ♯ e ♭ (#11)". O texto completo é preservado para acessibilidade. A avaliação atual está registrada abaixo; a validação no Linux permanece pendente.

## Alinhamento vertical de ♯ e ♭ (#11)

Método: bbox dos glifos medido nos arquivos de `app/assets/fonts/` com fontTools (em em). Noto Music: ♯ vai de −0,247 a 0,509 (centro 0,131); ♭ de −0,055 a 0,615 (centro 0,280). Meia altura de maiúsculas: Space Grotesk 0,350, Atkinson Hyperlegible 0,334.

Resultado: o deslocamento único de 16% deixava ♯ baixo (centro 0,29 contra 0,35 no título) e ♭ alto. Alternativas avaliadas: aumentar o deslocamento único (corrige ♯ e piora ♭) e fallback de sistema sem ajuste (glifos variam por plataforma). Escolha: `musicGlyphRise` centraliza cada glifo na altura de maiúsculas da família principal — ♯ sobe 21,9% (título) / 20,3% (corpo) e ♭ sobe 7,0% / 5,4%, o que apoia o bojo do ♭ na linha de base. O texto acessível segue sendo a string original.

QA verificou visualmente ♯ e ♭ em títulos e corpo, nos temas claro e escuro, no simulador iPhone 17 (iOS) e no macOS. As árvores de acessibilidade preservaram as strings originais. No iOS em paisagem, é necessário rolar para ver a parte inferior. O VoiceOver não foi testado. Android e Linux não foram verificados e seguem pendentes.

No macOS, `flutter test` passou em 13 testes, incluindo os layouts compacto e expandido. Prints e índice estão em `pr-assets/issue-11/4348d9a/`, referentes ao código testado.
