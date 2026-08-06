import SwiftUI

struct LearningTrailView: View {
    private let steps = LearningStep.sampleTrail
    private let horizontalPositions: [CGFloat] = [0.50, 0.27, 0.69, 0.34, 0.71, 0.29, 0.57]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    trailHeader
                    trailMap
                }
            }
            .background(BlinkTheme.ink)
            .navigationTitle("Trilha")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(BlinkTheme.ink.opacity(0.96), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Label("Unidade 2", systemImage: "bolt.circle.fill")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(BlinkTheme.orange)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Label("7", systemImage: "flame.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(BlinkTheme.orange)
                }
            }
            .navigationDestination(for: LearningStep.self) { step in
                LearningChallengeDetailView(step: step)
            }
        }
    }

    private var trailHeader: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("UNIDADE 2")
                        .font(.system(size: 11, weight: .black))
                        .tracking(1.2)
                        .foregroundStyle(BlinkTheme.orange)
                    Text("Componentes essenciais")
                        .font(.system(size: 25, weight: .black, design: .rounded))
                        .foregroundStyle(.white)
                    Text("Domine os componentes que dão vida aos circuitos.")
                        .font(.system(size: 14))
                        .foregroundStyle(.white.opacity(0.62))
                }

                Spacer(minLength: 0)

                progressRing
            }

            HStack(spacing: 8) {
                Label("3 de 7 desafios", systemImage: "map.fill")
                Spacer()
                Label("280 XP ganhos", systemImage: "bolt.fill")
            }
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(.white.opacity(0.72))
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [BlinkTheme.orange.opacity(0.30), BlinkTheme.ink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(alignment: .bottom) {
            Rectangle().fill(BlinkTheme.orange).frame(height: 3)
        }
    }

    private var progressRing: some View {
        ZStack {
            Circle().stroke(.white.opacity(0.12), lineWidth: 7)
            Circle()
                .trim(from: 0, to: 0.42)
                .stroke(BlinkTheme.orange, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("42%")
                .font(.system(size: 12, weight: .black))
                .foregroundStyle(.white)
        }
        .frame(width: 64, height: 64)
    }

    private var trailMap: some View {
        ZStack(alignment: .top) {
            BlinkTheme.ink

            Image("TrailBackground")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: mapHeight)
                .clipped()

            LinearGradient(
                colors: [BlinkTheme.ink.opacity(0.15), .clear, BlinkTheme.ink.opacity(0.42)],
                startPoint: .top,
                endPoint: .bottom
            )

            GeometryReader { proxy in
                TrailRouteShape(positions: horizontalPositions, rowCount: steps.count)
                    .stroke(
                        .white.opacity(0.20),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round, dash: [3, 22])
                    )

                TrailRouteShape(positions: Array(horizontalPositions.prefix(3)), rowCount: steps.count)
                    .stroke(
                        BlinkTheme.orange.opacity(0.85),
                        style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round)
                    )
            }
            .padding(.horizontal, 12)

            VStack(spacing: 0) {
                ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                    GeometryReader { proxy in
                        NavigationLink(value: step) {
                            ChallengeMapNode(step: step)
                        }
                        .buttonStyle(.plain)
                        .position(
                            x: proxy.size.width * horizontalPositions[index],
                            y: rowHeight / 2
                        )
                    }
                    .frame(height: rowHeight)
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(height: mapHeight)
        .overlay(alignment: .top) {
            Text("TOQUE EM UM DESAFIO PARA VER OS DETALHES")
                .font(.system(size: 10, weight: .black))
                .tracking(1)
                .foregroundStyle(.white.opacity(0.68))
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(BlinkTheme.ink.opacity(0.80))
                .clipShape(Capsule())
                .padding(.top, 14)
        }
    }

    private var rowHeight: CGFloat { 150 }
    private var mapHeight: CGFloat { rowHeight * CGFloat(steps.count) }
}

private struct ChallengeMapNode: View {
    let step: LearningStep

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(shadowColor)
                    .frame(width: 82, height: 82)
                    .offset(y: 8)

                Circle()
                    .fill(nodeFill)
                    .frame(width: 82, height: 82)
                    .overlay {
                        Circle().stroke(borderColor, lineWidth: step.status == .current ? 6 : 3)
                    }
                    .shadow(color: glowColor, radius: step.status == .current ? 16 : 7)

                VStack(spacing: 2) {
                    Image(systemName: nodeIcon)
                        .font(.system(size: 24, weight: .black))
                    Text("\(step.id)")
                        .font(.system(size: 12, weight: .black, design: .rounded))
                }
                .foregroundStyle(iconColor)
            }
            .overlay(alignment: .topTrailing) {
                if step.status == .current {
                    Text("AGORA")
                        .font(.system(size: 8, weight: .black))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background(BlinkTheme.orange)
                        .clipShape(Capsule())
                        .offset(x: 22, y: -5)
                }
            }

            Text(step.title)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(step.status == .locked ? .white.opacity(0.60) : .white)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(BlinkTheme.ink.opacity(0.88))
                .clipShape(Capsule())
                .overlay { Capsule().stroke(borderColor.opacity(0.65), lineWidth: 1) }
        }
        .accessibilityLabel("Desafio \(step.id): \(step.title), \(step.subtitle)")
    }

    private var nodeIcon: String {
        switch step.status {
        case .completed: return "checkmark"
        case .current: return step.icon
        case .locked: return "lock.fill"
        }
    }

    private var nodeFill: Color {
        switch step.status {
        case .completed: return BlinkTheme.orange
        case .current: return .white
        case .locked: return BlinkTheme.graphite
        }
    }

    private var shadowColor: Color {
        step.status == .locked ? Color.black.opacity(0.55) : BlinkTheme.orangeDark
    }

    private var borderColor: Color {
        switch step.status {
        case .completed: return BlinkTheme.orangeSoft
        case .current: return BlinkTheme.orange
        case .locked: return .white.opacity(0.15)
        }
    }

    private var iconColor: Color {
        switch step.status {
        case .completed: return .white
        case .current: return BlinkTheme.orange
        case .locked: return .white.opacity(0.42)
        }
    }

    private var glowColor: Color {
        step.status == .locked ? .clear : BlinkTheme.orange.opacity(0.45)
    }
}

private struct TrailRouteShape: Shape {
    let positions: [CGFloat]
    let rowCount: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let first = positions.first else { return path }

        let rowHeight = rect.height / CGFloat(max(rowCount, 1))
        var current = CGPoint(x: rect.width * first, y: rowHeight / 2)
        path.move(to: current)

        for index in 1..<positions.count {
            let next = CGPoint(
                x: rect.width * positions[index],
                y: rowHeight * (CGFloat(index) + 0.5)
            )
            let middleY = (current.y + next.y) / 2
            path.addCurve(
                to: next,
                control1: CGPoint(x: current.x, y: middleY),
                control2: CGPoint(x: next.x, y: middleY)
            )
            current = next
        }

        return path
    }
}

struct LearningChallengeDetailView: View {
    let step: LearningStep

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                hero
                quickFacts
                informationCard(
                    title: "Sobre este desafio",
                    icon: "doc.text.fill",
                    content: step.summary
                )
                objectiveCard
                componentsCard
                challengeCard
                actionButton
            }
            .padding(BlinkTheme.horizontalPadding)
            .padding(.bottom, 30)
        }
        .background(BlinkTheme.surface)
        .navigationTitle("Desafio \(step.id)")
        .navigationBarTitleDisplayMode(.inline)
        .tint(BlinkTheme.orange)
    }

    private var hero: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(BlinkTheme.orange.opacity(0.16))
                    .frame(width: 112, height: 112)
                Circle()
                    .stroke(BlinkTheme.orange.opacity(0.35), lineWidth: 2)
                    .frame(width: 94, height: 94)
                Image(systemName: step.status == .locked ? "lock.fill" : step.icon)
                    .font(.system(size: 42, weight: .black))
                    .foregroundStyle(BlinkTheme.orange)
            }

            VStack(spacing: 5) {
                statusLabel
                Text(step.title)
                    .font(.system(size: 27, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                Text(step.subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.62))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 26)
        .padding(.horizontal, 18)
        .background(
            LinearGradient(
                colors: [BlinkTheme.ink, BlinkTheme.orangeDark.opacity(0.88)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .blinkShadow()
    }

    private var statusLabel: some View {
        Text(statusText)
            .font(.system(size: 10, weight: .black))
            .tracking(1)
            .foregroundStyle(step.status == .current ? BlinkTheme.ink : .white)
            .padding(.horizontal, 11)
            .padding(.vertical, 6)
            .background(step.status == .current ? BlinkTheme.orange : .white.opacity(0.15))
            .clipShape(Capsule())
    }

    private var statusText: String {
        switch step.status {
        case .completed: return "CONCLUÍDO"
        case .current: return "DISPONÍVEL AGORA"
        case .locked: return "BLOQUEADO"
        }
    }

    private var quickFacts: some View {
        HStack(spacing: 10) {
            fact(icon: "clock.fill", value: step.duration, label: "Duração")
            fact(icon: "speedometer", value: step.difficulty, label: "Nível")
            fact(icon: "bolt.fill", value: "+\(step.xp) XP", label: "Recompensa")
        }
    }

    private func fact(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(BlinkTheme.orange)
            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(BlinkTheme.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(BlinkTheme.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 17).stroke(BlinkTheme.line) }
    }

    private func informationCard(title: String, icon: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle(title, icon: icon)
            Text(content)
                .font(.system(size: 14))
                .foregroundStyle(BlinkTheme.graphite)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .blinkCard()
    }

    private var objectiveCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("O que você vai praticar", icon: "target")
            ForEach(step.objectives, id: \.self) { objective in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(BlinkTheme.orange)
                    Text(objective)
                        .font(.system(size: 14))
                        .foregroundStyle(BlinkTheme.graphite)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .blinkCard()
    }

    private var componentsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Componentes", icon: "cpu.fill")
            if step.components.isEmpty {
                Text("Você não precisa de componentes físicos nesta etapa.")
                    .font(.system(size: 14))
                    .foregroundStyle(BlinkTheme.muted)
            } else {
                FlowLayout(items: step.components)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .blinkCard()
    }

    private var challengeCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Missão da etapa", systemImage: "flag.checkered")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(BlinkTheme.orange)
            Text(step.challenge)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(BlinkTheme.ink)
        .clipShape(RoundedRectangle(cornerRadius: BlinkTheme.cardRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: BlinkTheme.cardRadius)
                .stroke(BlinkTheme.orange.opacity(0.65), lineWidth: 1)
        }
    }

    private var actionButton: some View {
        Button {} label: {
            Label(actionTitle, systemImage: actionIcon)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(OrangeButtonStyle())
        .disabled(step.status == .locked)
        .opacity(step.status == .locked ? 0.48 : 1)
    }

    private var actionTitle: String {
        switch step.status {
        case .completed: return "Refazer desafio"
        case .current: return "Começar desafio"
        case .locked: return "Conclua o desafio anterior"
        }
    }

    private var actionIcon: String {
        switch step.status {
        case .completed: return "arrow.clockwise"
        case .current: return "play.fill"
        case .locked: return "lock.fill"
        }
    }

    private func sectionTitle(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(BlinkTheme.ink)
    }
}

private struct FlowLayout: View {
    let items: [String]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 105), spacing: 8)], alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(BlinkTheme.orangeDark)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 9)
                    .background(BlinkTheme.orangeSoft)
                    .clipShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
            }
        }
    }
}

private extension LearningStep {
    static let sampleTrail: [LearningStep] = [
        LearningStep(
            id: 1,
            title: "Energia em movimento",
            subtitle: "Fundamentos concluídos",
            icon: "bolt.fill",
            status: .completed,
            xp: 50,
            duration: "8 min",
            difficulty: "Iniciante",
            summary: "Descubra de onde vem a energia elétrica e como ela se movimenta por um circuito fechado.",
            objectives: ["Reconhecer fonte, carga e caminho elétrico", "Diferenciar circuito aberto e fechado"],
            components: [],
            challenge: "Identifique por onde a corrente consegue passar em três circuitos diferentes."
        ),
        LearningStep(
            id: 2,
            title: "Tensão e corrente",
            subtitle: "Concluído",
            icon: "waveform.path.ecg",
            status: .completed,
            xp: 80,
            duration: "12 min",
            difficulty: "Iniciante",
            summary: "Entenda a diferença entre a força que empurra os elétrons e o fluxo que percorre o circuito.",
            objectives: ["Comparar tensão e corrente", "Escolher a unidade correta: volt ou ampère"],
            components: ["Bateria 9 V", "Multímetro"],
            challenge: "Meça a tensão de uma bateria e selecione a escala correta do multímetro."
        ),
        LearningStep(
            id: 3,
            title: "Resistores na prática",
            subtitle: "Aula 4 de 6",
            icon: "resistor",
            status: .current,
            xp: 100,
            duration: "15 min",
            difficulty: "Iniciante",
            summary: "Aprenda por que resistores protegem componentes e decifre o valor deles usando as faixas coloridas.",
            objectives: ["Ler o código de cores", "Entender resistência e tolerância", "Escolher um resistor seguro para um LED"],
            components: ["LED vermelho", "Resistor 220 Ω", "Bateria 9 V", "Protoboard"],
            challenge: "Escolha o resistor correto e monte um circuito que acenda o LED sem danificá-lo."
        ),
        LearningStep(
            id: 4,
            title: "Lei de Ohm",
            subtitle: "Conclua o desafio 3",
            icon: "function",
            status: .locked,
            xp: 120,
            duration: "18 min",
            difficulty: "Básico",
            summary: "Relacione tensão, corrente e resistência para prever o comportamento de circuitos simples.",
            objectives: ["Aplicar V = R × I", "Calcular uma grandeza desconhecida"],
            components: ["Calculadora", "Multímetro"],
            challenge: "Calcule e depois confirme na bancada a corrente de três circuitos resistivos."
        ),
        LearningStep(
            id: 5,
            title: "Circuitos em série",
            subtitle: "Bloqueado",
            icon: "point.3.connected.trianglepath.dotted",
            status: .locked,
            xp: 150,
            duration: "20 min",
            difficulty: "Básico",
            summary: "Conecte componentes em um único caminho e observe como tensão e resistência se distribuem.",
            objectives: ["Somar resistências em série", "Medir quedas de tensão"],
            components: ["3 resistores", "Protoboard", "Jumpers", "Multímetro"],
            challenge: "Monte uma cadeia de três resistores e confira a queda de tensão em cada um."
        ),
        LearningStep(
            id: 6,
            title: "LEDs e polaridade",
            subtitle: "Bloqueado",
            icon: "lightbulb.led.fill",
            status: .locked,
            xp: 180,
            duration: "22 min",
            difficulty: "Básico",
            summary: "Identifique ânodo e cátodo e use LEDs com segurança em diferentes fontes.",
            objectives: ["Reconhecer a polaridade do LED", "Evitar corrente excessiva"],
            components: ["LEDs", "Resistores", "Fonte 5 V", "Protoboard"],
            challenge: "Monte duas indicações luminosas com cores e resistores diferentes."
        ),
        LearningStep(
            id: 7,
            title: "Projeto: Semáforo",
            subtitle: "Desafio da unidade",
            icon: "trafficlight",
            status: .locked,
            xp: 250,
            duration: "40 min",
            difficulty: "Projeto",
            summary: "Combine tudo o que aprendeu em um circuito sequencial de sinalização com três LEDs.",
            objectives: ["Planejar um circuito completo", "Organizar componentes na protoboard", "Testar e corrigir a montagem"],
            components: ["3 LEDs", "3 resistores", "Protoboard", "Jumpers", "Arduino"],
            challenge: "Construa um semáforo funcional e explique a função de cada resistor no circuito."
        )
    ]
}
