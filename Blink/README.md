# Blink — versão de demonstração

Aplicativo educacional em SwiftUI com o frontend integrado e
funcionamento local.

## Interface

- **Trilha**: percurso pontilhado, progresso e página de detalhes de cada etapa.
- **Bancada**: componentes, projetos em andamento e itens salvos.
- **Câmera**: terceira aba da `TabView`, com diagnóstico em tempo real.
- **FalaFio**: feed, detalhes dos posts, comentários locais, filtros, curtidas,
  salvos e nova publicação.
- **Blink**: chat local com sugestões rápidas.

A identidade visual usa paleta laranja/carvão/areia, tipografia de sistema,
superfícies planas, hairlines e os sprites do mascote.

## Dados e integrações

Trilha, projetos e o feed inicial do FalaFio usam os mocks declarados em
`Models/FrontendMocks.swift`. Os componentes da Bancada aparecem somente depois
de serem reconhecidos pela câmera. A única ação enviada ao serviço local é a
nova publicação do usuário no FalaFio, pela rota `/postar_user` já existente.

A câmera usa AVFoundation, Vision, o modelo Core ML `Blink.mlmodel` e o catálogo
local. Chat, progresso pessoal, curtidas e salvos também permanecem locais.
Esses valores usam `@State` e `@Binding`: mudam durante o uso e voltam aos
mocks quando o aplicativo é reiniciado.

## Para rodar

1. Abra `Blink.xcodeproj` no Xcode.
2. Deixe o serviço local já existente acessível no endereço usado por
   `PostsObservable.swift` para testar uma publicação.
3. Execute no simulador ou em um iPhone; o preview real da câmera exige aparelho.

O projeto usa grupos sincronizados do Xcode, portanto os arquivos dentro de
`Blink/` são incluídos automaticamente no target.
