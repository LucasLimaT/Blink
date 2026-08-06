# Blink — frontend SwiftUI

Protótipo navegável do Blink, um aplicativo educacional para aprender eletrônica.

## Como usar

1. No Xcode, crie um projeto **iOS App** chamado `Blink` com SwiftUI.
2. Apague os arquivos Swift gerados automaticamente.
3. Arraste todos os arquivos `.swift` desta pasta para o projeto e marque o target `Blink`.
4. Arraste `Resources/TrailBackground.png` para o Xcode, marque **Copy items if needed** e confirme o target `Blink`.
5. Execute em um simulador com iOS 16 ou superior.

> O nome do recurso deve continuar exatamente `TrailBackground.png`, pois a trilha o carrega com `Image("TrailBackground")`.

O protótipo usa apenas SwiftUI e SF Symbols. A análise da câmera e o envio das publicações estão simulados localmente para permitir testar todo o fluxo visual sem backend.

## Telas incluídas

- Home com progresso, sequência, XP e continuação da aula.
- Trilha de aprendizagem em zigue-zague sobre um cenário original de eletrônica.
- Página de detalhes para cada desafio, com objetivos, componentes, duração, XP e bloqueio por progresso.
- Câmera central em destaque com leitura simulada de componentes.
- Resultado da análise com componentes encontrados e sugestão de projeto.
- Comunidade com filtros, curtidas, criação de post e tela de detalhes com comentários.
- Chat com o Blink, mascote desenhado inteiramente em SwiftUI.
