import Foundation

enum FrontendMocks {
    static let modules: [Module] = [
        Module(
            id: "module-1",
            label: "Tensão e corrente",
            state: .done,
            detail: "Entenda o que faz a energia circular por um circuito.",
            topics: [
                "Diferença entre tensão e corrente",
                "Unidades volt e ampere",
                "Como medir com o multímetro"
            ],
            example: "Uma bateria de 9 V fornece a tensão que empurra a corrente pelos componentes.",
            activity: "Meça a tensão de uma bateria e anote o valor encontrado."
        ),
        Module(
            id: "module-2",
            label: "Lei de Ohm",
            state: .done,
            detail: "Relacione tensão, corrente e resistência em um circuito.",
            topics: [
                "Fórmula V = R × I",
                "Como encontrar a corrente",
                "Como escolher uma resistência"
            ],
            example: "Em 5 V com um resistor de 220 Ω, a corrente fica próxima de 23 mA.",
            activity: "Calcule a corrente de um circuito de 9 V com resistor de 1 kΩ."
        ),
        Module(
            id: "module-3",
            label: "Resistores",
            state: .current,
            detail: "Identifique valores pelo código de cores e monte o primeiro divisor de tensão na protoboard.",
            topics: [
                "Função do resistor",
                "Código de cores",
                "Montagem na protoboard"
            ],
            example: "Vermelho, vermelho e marrom representam um resistor de 220 Ω.",
            activity: "Separe três resistores, descubra seus valores e confira com o multímetro."
        ),
        Module(
            id: "unit-1-chest",
            label: "Baú da unidade",
            state: .chest,
            detail: "Conclua as três primeiras etapas para abrir o baú e ganhar 120 XP.",
            topics: [],
            example: "A recompensa deste baú é de 120 XP.",
            activity: "Continue avançando pela trilha para liberar a recompensa."
        ),
        Module(
            id: "module-4",
            label: "Série e paralelo",
            state: .locked,
            detail: "Aprenda duas maneiras de ligar componentes no mesmo circuito.",
            topics: [
                "Ligação em série",
                "Ligação em paralelo",
                "Divisão de tensão e corrente"
            ],
            example: "Em série, a mesma corrente passa por todos os componentes.",
            activity: "Monte dois LEDs em série e depois compare com uma montagem em paralelo."
        ),
        Module(
            id: "module-5",
            label: "Capacitores",
            state: .locked,
            detail: "Descubra como armazenar energia por um pequeno intervalo.",
            topics: [
                "Capacitância",
                "Carga e descarga",
                "Polaridade dos capacitores"
            ],
            example: "Um capacitor pode manter um LED aceso por alguns instantes após desligar a fonte.",
            activity: "Observe a carga e a descarga de um capacitor usando um LED."
        ),
        Module(
            id: "module-6",
            label: "Diodos e LEDs",
            state: .locked,
            detail: "Controle o sentido da corrente e use LEDs com segurança.",
            topics: [
                "Ânodo e cátodo",
                "Queda de tensão",
                "Resistor de proteção"
            ],
            example: "O terminal mais longo do LED normalmente é o ânodo positivo.",
            activity: "Acenda um LED com uma bateria e um resistor de 220 Ω."
        ),
        Module(
            id: "module-7",
            label: "Projeto: semáforo",
            state: .locked,
            detail: "Projeto final da unidade usando três LEDs e um Arduino.",
            topics: [
                "Organização do circuito",
                "Sequência dos LEDs",
                "Tempo de cada sinal"
            ],
            example: "O Arduino alterna os LEDs verde, amarelo e vermelho usando pequenos intervalos.",
            activity: "Monte o semáforo e ajuste o tempo de cada luz no código."
        )
    ]

    static let posts: [Post] = [
        Post(
            id: "post-1",
            author: "Pedro Alves",
            initials: "PA",
            time: "há 2 h",
            category: .problema,
            isTutor: false,
            hasPhoto: true,
            title: "Meu LED não acende no pino 9",
            body: "Montei igual ao esquema da trilha, mas nada. O ponto 1 é onde ligo o LED direto no pino; o 2 é o resistor que sobrou na protoboard.",
            likes: 4,
            comments: 11,
            liked: false,
            saved: false
        ),
        Post(
            id: "post-2",
            author: "Blink",
            initials: "BK",
            time: "há 2 h",
            category: .dica,
            isTutor: true,
            hasPhoto: false,
            title: "Sempre um resistor em série com o LED",
            body: "Um LED vermelho comum trabalha em torno de 2 V e 20 mA. Em 5 V, use 150 Ω a 220 Ω em série — sem ele, a corrente dispara e a junção queima.",
            likes: 38,
            comments: 3,
            liked: true,
            saved: true
        ),
        Post(
            id: "post-3",
            author: "Marina Silva",
            initials: "MS",
            time: "há 5 h",
            category: .duvida,
            isTutor: false,
            hasPhoto: false,
            title: "Dá pra usar 470 Ω no lugar de 220 Ω?",
            body: "Só tenho resistores de 470 Ω em casa. O LED vai acender mais fraco ou nem liga?",
            likes: 9,
            comments: 6,
            liked: false,
            saved: false
        ),
        Post(
            id: "post-4",
            author: "Ana Costa",
            initials: "AC",
            time: "há 1 dia",
            category: .conquista,
            isTutor: false,
            hasPhoto: false,
            title: "Terminei a etapa de resistores",
            body: "Medi tensão e corrente em três montagens diferentes e o cálculo bateu com o multímetro nas três. Próxima parada: capacitores.",
            likes: 27,
            comments: 4,
            liked: false,
            saved: false
        )
    ]

    static let inventory: [InventoryItem] = []

    static let projects: [ProjectItem] = [
        ProjectItem(
            id: "project-1",
            name: "Semáforo de 3 LEDs",
            progress: 70,
            nextStep: "Falta ajustar o tempo do amarelo no código."
        ),
        ProjectItem(
            id: "project-2",
            name: "Divisor de tensão",
            progress: 25,
            nextStep: "Próximo passo: medir a saída com o multímetro."
        )
    ]

    static let savedExtra = SavedItem(
        id: "saved-extra",
        title: "Como ler o código de cores sem tabela",
        author: "Ana Costa · Dica"
    )

    static let suggestions: [Suggestion] = [
        Suggestion(
            label: "Como funciona um resistor?",
            reply: "Ele limita a corrente. Pela Lei de Ohm, I = V / R: quanto maior o resistor, menor a corrente. Num LED de 5 V com 220 Ω sobram cerca de 13 mA — seguro para a junção."
        ),
        Suggestion(
            label: "Quero uma ideia de projeto",
            reply: "Com o que está na sua bancada dá para montar um semáforo de 3 LEDs no Arduino. Leva 3 resistores de 220 Ω, 3 LEDs e uns 20 minutos."
        ),
        Suggestion(
            label: "Por que meu LED queimou?",
            reply: "Provavelmente faltou resistor em série. Sem ele a corrente passa de 20 mA e a junção aquece até romper. Mande uma foto da montagem que eu confiro."
        )
    ]

    static func comments(postID: String) -> [Comment] {
        switch postID {
        case "post-1":
            return [
                Comment(
                    author: "Blink",
                    content: "Confira a polaridade do LED. A perna mais longa deve ficar voltada para o pino 9."
                ),
                Comment(
                    author: "Marina Silva",
                    content: "Também veja se o GND do Arduino está ligado ao negativo da protoboard."
                ),
                Comment(
                    author: "Pedro Alves",
                    content: "Era o LED invertido. Troquei a posição e funcionou!"
                )
            ]

        case "post-2":
            return [
                Comment(
                    author: "Ana Costa",
                    content: "Essa dica salvou meu primeiro LED. Agora sempre começo pelo resistor."
                ),
                Comment(
                    author: "Lucas Taveira",
                    content: "Com 220 Ω funcionou bem na saída de 5 V do Arduino."
                )
            ]

        case "post-3":
            return [
                Comment(
                    author: "Blink",
                    content: "Pode usar. Com 470 Ω a corrente será menor e o LED ficará um pouco mais fraco."
                ),
                Comment(
                    author: "Marina Silva",
                    content: "Testei aqui e acendeu. Obrigada!"
                )
            ]

        case "post-4":
            return [
                Comment(
                    author: "Pedro Alves",
                    content: "Parabéns! Comparar o cálculo com a medição ajuda muito a entender."
                ),
                Comment(
                    author: "Blink",
                    content: "Ótimo trabalho. Capacitores serão o próximo desafio da trilha."
                )
            ]

        default:
            return []
        }
    }
}
