import Foundation

enum MockData {
    static let electronicComponents: [ElectronicComponent] = [
        ElectronicComponent(
            id: "Esp",
            name: "ESP32 / ESP8266",
            detail: "Microcontrolador com Wi-Fi e Bluetooth",
            photoURL: nil,
            icon: "cpu"
        ),
        ElectronicComponent(
            id: "Protoboard",
            name: "Protoboard",
            detail: "Matriz para montagem sem solda",
            photoURL: nil,
            icon: "rectangle.grid.3x2.fill"
        ),
        ElectronicComponent(
            id: "rfid",
            name: "Módulo RFID",
            detail: "Leitor de identificação por radiofrequência",
            photoURL: nil,
            icon: "wave.3.right.circle.fill"
        ),
        ElectronicComponent(
            id: "led",
            name: "LED",
            detail: "Diodo emissor de luz com polaridade definida",
            photoURL: nil,
            icon: "lightbulb.led.fill"
        ),
        ElectronicComponent(
            id: "sensor de humidade",
            name: "Sensor de umidade",
            detail: "Sensor para medir a umidade do ambiente ou do solo",
            photoURL: nil,
            icon: "drop.fill"
        )
    ]

    static func chatReply(message: String) -> String {
        let text = message.folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: .current
        )

        if text.contains("resistor") {
            return "O resistor limita a corrente do circuito. Para escolher um para LED, use R = (Vfonte − Vled) ÷ I. Em uma fonte de 5 V com LED de 2 V e corrente de 15 mA, o valor fica perto de 200 Ω; 220 Ω é uma opção comum."
        }
        if text.contains("ohm") || text.contains("tensao") || text.contains("corrente") {
            return "A Lei de Ohm liga tensão, corrente e resistência: V = R × I. Se você souber duas dessas grandezas, consegue calcular a terceira."
        }
        if text.contains("projeto") || text.contains("ideia") {
            return "Uma ideia simples é montar um semáforo com três LEDs, três resistores de 220 Ω e um Arduino. Comece acendendo um LED por vez e depois programe a sequência."
        }
        if text.contains("led") {
            return "LED tem polaridade: a perna maior costuma ser o ânodo (+) e a menor, o cátodo (−). Use sempre um resistor em série para limitar a corrente."
        }

        return "Para a demonstração eu estou em modo local. Posso explicar resistores, LEDs, Lei de Ohm ou sugerir um projeto simples."
    }

    static func projectSuggestion(components: [String]) -> ProjectSuggestion {
        let names = components.joined(separator: " ").folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: .current
        )

        if names.contains("rfid") {
            return ProjectSuggestion(
                title: "Controle de acesso com RFID",
                description: "Use o leitor RFID para liberar o acesso quando uma tag cadastrada for aproximada.",
                url: nil
            )
        }

        if names.contains("esp") {
            return ProjectSuggestion(
                title: "Painel Wi-Fi com ESP",
                description: "Monte um pequeno painel que liga um LED pela rede local usando o ESP32 ou ESP8266.",
                url: nil
            )
        }

        return ProjectSuggestion(
            title: "Montagem rápida na protoboard",
            description: "Organize os componentes identificados em uma montagem simples para testar alimentação e conexões.",
            url: nil
        )
    }
}
