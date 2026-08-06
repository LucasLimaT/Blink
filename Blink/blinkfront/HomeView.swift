import SwiftUI

struct HomeView: View {
    let openTrail: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    header
                    greeting
                    continueCard
                    stats
                    sectionHeader
                    miniTrail
                    tipCard
                }
                .padding(.horizontal, BlinkTheme.horizontalPadding)
                .padding(.bottom, 30)
            }
            .background(BlinkTheme.surface)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var header: some View {
        HStack {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(BlinkTheme.ink)
                        .frame(width: 42, height: 42)
                    Image(systemName: "bolt.fill")
                        .foregroundStyle(BlinkTheme.orange)
                }
                Text("blink")
                    .font(.system(size: 27, weight: .black, design: .rounded))
                    .foregroundStyle(BlinkTheme.ink)
            }

            Spacer()

            HStack(spacing: 14) {
                Label("7", systemImage: "flame.fill")
                    .foregroundStyle(BlinkTheme.orange)
                    .font(.system(size: 15, weight: .bold))
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(BlinkTheme.ink)
            }
        }
        .padding(.top, 12)
    }

    private var greeting: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Boa noite, Lucas!")
                    .font(.system(size: 27, weight: .bold, design: .rounded))
                    .foregroundStyle(BlinkTheme.ink)
                Text("Pronto para fazer uma ideia acender?")
                    .font(.system(size: 15))
                    .foregroundStyle(BlinkTheme.muted)
            }
            Spacer()
            BlinkMascot(size: 70, mood: .happy)
        }
    }

    private var continueCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("CONTINUE DE ONDE PAROU")
                    .font(.system(size: 11, weight: .black))
                    .tracking(0.8)
                    .foregroundStyle(.white.opacity(0.72))
                Spacer()
                Text("65%")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(BlinkTheme.orange)
            }

            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.white.opacity(0.1))
                        .frame(width: 58, height: 58)
                    Image(systemName: "resistor")
                        .font(.system(size: 27, weight: .bold))
                        .foregroundStyle(BlinkTheme.orange)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Resistores na prática")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Unidade 2 · Aula 4 de 6")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.62))
                }
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(.white.opacity(0.12))
                    Capsule().fill(BlinkTheme.orange).frame(width: proxy.size.width * 0.65)
                }
            }
            .frame(height: 8)

            Button(action: openTrail) {
                Label("Continuar aprendendo", systemImage: "arrow.right")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(OrangeButtonStyle())
        }
        .padding(20)
        .background(BlinkTheme.ink)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .blinkShadow()
    }

    private var stats: some View {
        HStack(spacing: 10) {
            stat(icon: "bolt.fill", value: "1.240", label: "XP total", color: BlinkTheme.orange)
            stat(icon: "trophy.fill", value: "12", label: "Projetos", color: Color.yellow)
            stat(icon: "target", value: "82%", label: "Precisão", color: Color.green)
        }
    }

    private func stat(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon).foregroundStyle(color)
            Text(value).font(.system(size: 16, weight: .bold)).foregroundStyle(BlinkTheme.ink)
            Text(label).font(.system(size: 10, weight: .medium)).foregroundStyle(BlinkTheme.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 17).stroke(BlinkTheme.line) }
    }

    private var sectionHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("Sua trilha")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(BlinkTheme.ink)
                Text("Fundamentos da eletrônica")
                    .font(.system(size: 13))
                    .foregroundStyle(BlinkTheme.muted)
            }
            Spacer()
            Button("Ver tudo", action: openTrail)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(BlinkTheme.orange)
        }
    }

    private var miniTrail: some View {
        HStack(spacing: 0) {
            miniStep(icon: "checkmark", title: "Tensão", done: true)
            connector(done: true)
            miniStep(icon: "resistor", title: "Resistor", done: false)
            connector(done: false)
            miniStep(icon: "lock.fill", title: "Circuitos", done: false, locked: true)
        }
        .blinkCard()
    }

    private func miniStep(icon: String, title: String, done: Bool, locked: Bool = false) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(done ? BlinkTheme.orange : (locked ? BlinkTheme.line : BlinkTheme.ink))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(locked ? BlinkTheme.muted : .white)
            }
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(locked ? BlinkTheme.muted : BlinkTheme.ink)
        }
    }

    private func connector(done: Bool) -> some View {
        Capsule()
            .fill(done ? BlinkTheme.orange : BlinkTheme.line)
            .frame(height: 4)
            .padding(.horizontal, 5)
            .offset(y: -12)
    }

    private var tipCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 24))
                .foregroundStyle(BlinkTheme.orange)
                .frame(width: 46, height: 46)
                .background(BlinkTheme.orangeSoft)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 3) {
                Text("Dica do Blink")
                    .font(.system(size: 14, weight: .bold))
                Text("A faixa dourada indica a tolerância de um resistor.")
                    .font(.system(size: 13))
                    .foregroundStyle(BlinkTheme.muted)
            }
            Spacer()
        }
        .blinkCard(padding: 14)
    }
}

