import SwiftUI

struct ScannerView: View {
    @State private var isScanning = false
    @State private var showResult = false
    @State private var flashOn = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.black, Color(red: 0.10, green: 0.10, blue: 0.11)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                Spacer()
                scanArea
                Spacer()
                instructions
                controls
            }
            .padding(.horizontal, 22)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
        .sheet(isPresented: $showResult) {
            AnalysisResultView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("Blink Vision")
                    .font(.system(size: 23, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("Aponte para seus componentes")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.58))
            }
            Spacer()
            Button { flashOn.toggle() } label: {
                Image(systemName: flashOn ? "bolt.fill" : "bolt.slash.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(flashOn ? BlinkTheme.orange : .white)
                    .frame(width: 44, height: 44)
                    .background(.white.opacity(0.1))
                    .clipShape(Circle())
            }
        }
    }

    private var scanArea: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.02)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .aspectRatio(0.84, contentMode: .fit)

            VStack(spacing: 34) {
                HStack(spacing: 38) {
                    componentPlaceholder(icon: "resistor", name: "Resistor")
                    componentPlaceholder(icon: "lightbulb.led.fill", name: "LED")
                }
                HStack(spacing: 38) {
                    componentPlaceholder(icon: "switch.2", name: "Botão")
                    componentPlaceholder(icon: "battery.50percent", name: "Bateria")
                }
            }
            .opacity(isScanning ? 0.9 : 0.42)

            ScannerCorners()
                .stroke(BlinkTheme.orange, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .padding(16)

            if isScanning {
                Rectangle()
                    .fill(
                        LinearGradient(colors: [.clear, BlinkTheme.orange.opacity(0.75), .clear], startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(height: 2)
                    .padding(.horizontal, 24)
                    .transition(.opacity)
            }

            Text(isScanning ? "ANALISANDO..." : "POSICIONE OS ITENS AQUI")
                .font(.system(size: 11, weight: .black))
                .tracking(1.3)
                .foregroundStyle(isScanning ? BlinkTheme.orange : .white.opacity(0.7))
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(.black.opacity(0.66))
                .clipShape(Capsule())
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 30)
        }
    }

    private func componentPlaceholder(icon: String, name: String) -> some View {
        VStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 38, weight: .medium))
                .foregroundStyle(.white)
            Text(name)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))
        }
    }

    private var instructions: some View {
        HStack(spacing: 10) {
            Image(systemName: "sparkles")
                .foregroundStyle(BlinkTheme.orange)
            Text("Espalhe os componentes e mantenha a câmera parada")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.72))
        }
        .padding(.bottom, 18)
    }

    private var controls: some View {
        HStack {
            Button {} label: {
                Image(systemName: "photo.on.rectangle")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(.white.opacity(0.1))
                    .clipShape(Circle())
            }

            Spacer()

            Button(action: scan) {
                ZStack {
                    Circle().stroke(.white, lineWidth: 4).frame(width: 76, height: 76)
                    Circle().fill(BlinkTheme.orange).frame(width: 62, height: 62)
                    Image(systemName: isScanning ? "ellipsis" : "sparkles")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .disabled(isScanning)

            Spacer()

            Button {} label: {
                Image(systemName: "questionmark")
                    .font(.system(size: 19, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(.white.opacity(0.1))
                    .clipShape(Circle())
            }
        }
    }

    private func scan() {
        withAnimation { isScanning = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            isScanning = false
            showResult = true
        }
    }
}

private struct ScannerCorners: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let length: CGFloat = 42
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + length)); path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)); path.addLine(to: CGPoint(x: rect.minX + length, y: rect.minY))
        path.move(to: CGPoint(x: rect.maxX - length, y: rect.minY)); path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)); path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + length))
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - length)); path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)); path.addLine(to: CGPoint(x: rect.maxX - length, y: rect.maxY))
        path.move(to: CGPoint(x: rect.minX + length, y: rect.maxY)); path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)); path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - length))
        return path
    }
}

struct AnalysisResultView: View {
    @Environment(\.dismiss) private var dismiss

    private let components = [
        DetectedComponent(name: "LED vermelho", detail: "5 mm · 2 V", icon: "lightbulb.led.fill", confidence: 98),
        DetectedComponent(name: "Resistor", detail: "220 Ω · ±5%", icon: "resistor", confidence: 96),
        DetectedComponent(name: "Botão tátil", detail: "4 pinos", icon: "button.programmable", confidence: 93),
        DetectedComponent(name: "Bateria", detail: "9 V", icon: "battery.75percent", confidence: 91)
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    successHeader
                    componentList
                    projectCard
                    Button {} label: {
                        Label("Começar este projeto", systemImage: "hammer.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(OrangeButtonStyle())
                }
                .padding(20)
            }
            .background(BlinkTheme.surface)
            .navigationTitle("Análise concluída")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fechar") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private var successHeader: some View {
        HStack(spacing: 15) {
            BlinkMascot(size: 70, mood: .excited)
            VStack(alignment: .leading, spacing: 4) {
                Text("Boa! Encontrei 4 itens")
                    .font(.system(size: 20, weight: .bold))
                Text("Já tenho uma ideia perfeita para eles.")
                    .font(.system(size: 14))
                    .foregroundStyle(BlinkTheme.muted)
            }
            Spacer()
        }
    }

    private var componentList: some View {
        VStack(alignment: .leading, spacing: 13) {
            Text("COMPONENTES IDENTIFICADOS")
                .font(.system(size: 11, weight: .black))
                .tracking(0.8)
                .foregroundStyle(BlinkTheme.muted)
            ForEach(components) { component in
                HStack(spacing: 12) {
                    Image(systemName: component.icon)
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundStyle(BlinkTheme.orange)
                        .frame(width: 42, height: 42)
                        .background(BlinkTheme.orangeSoft)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(component.name).font(.system(size: 14, weight: .bold))
                        Text(component.detail).font(.system(size: 12)).foregroundStyle(BlinkTheme.muted)
                    }
                    Spacer()
                    Text("\(component.confidence)%")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.green)
                }
            }
        }
        .blinkCard()
    }

    private var projectCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("PROJETO SUGERIDO")
                    .font(.system(size: 11, weight: .black))
                    .tracking(0.8)
                    .foregroundStyle(BlinkTheme.orange)
                Spacer()
                Text("INICIANTE")
                    .font(.system(size: 10, weight: .black))
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(.green.opacity(0.15))
                    .foregroundStyle(.green)
                    .clipShape(Capsule())
            }
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 17).fill(BlinkTheme.ink)
                    Image(systemName: "light.beacon.max.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(BlinkTheme.orange)
                }
                .frame(width: 72, height: 72)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Alarme luminoso")
                        .font(.system(size: 20, weight: .bold))
                    Text("Acenda o LED ao pressionar o botão e aprenda o papel do resistor.")
                        .font(.system(size: 13))
                        .foregroundStyle(BlinkTheme.muted)
                        .lineLimit(3)
                }
            }
            HStack(spacing: 18) {
                Label("15 min", systemImage: "clock")
                Label("+100 XP", systemImage: "bolt.fill")
                Label("4 etapas", systemImage: "list.number")
            }
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(BlinkTheme.graphite)
        }
        .padding(18)
        .background(BlinkTheme.orangeSoft)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 22).stroke(BlinkTheme.orange.opacity(0.35)) }
    }
}

