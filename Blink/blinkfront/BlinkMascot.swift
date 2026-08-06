import SwiftUI

struct BlinkMascot: View {
    var size: CGFloat = 92
    var mood: Mood = .happy

    enum Mood {
        case happy, thinking, excited
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(BlinkTheme.orangeSoft)
                .frame(width: size, height: size)

            VStack(spacing: -2) {
                ZStack {
                    Capsule()
                        .fill(BlinkTheme.ink)
                        .frame(width: size * 0.52, height: size * 0.38)

                    HStack(spacing: size * 0.10) {
                        eye
                        eye
                    }
                    .offset(y: -size * 0.015)

                    Capsule()
                        .fill(.white.opacity(0.9))
                        .frame(width: size * 0.16, height: size * 0.035)
                        .offset(y: size * 0.10)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.10, style: .continuous)
                        .fill(BlinkTheme.orange)
                        .frame(width: size * 0.36, height: size * 0.25)

                    Image(systemName: "bolt.fill")
                        .font(.system(size: size * 0.11, weight: .black))
                        .foregroundStyle(.white)
                }
            }

            Capsule()
                .fill(BlinkTheme.graphite)
                .frame(width: size * 0.055, height: size * 0.19)
                .rotationEffect(.degrees(-16))
                .offset(x: -size * 0.28, y: size * 0.17)

            Capsule()
                .fill(BlinkTheme.graphite)
                .frame(width: size * 0.055, height: size * 0.19)
                .rotationEffect(.degrees(16))
                .offset(x: size * 0.28, y: size * 0.17)

            Capsule()
                .fill(BlinkTheme.ink)
                .frame(width: size * 0.05, height: size * 0.19)
                .offset(y: -size * 0.36)

            Circle()
                .fill(BlinkTheme.orange)
                .frame(width: size * 0.13, height: size * 0.13)
                .overlay(Circle().fill(.white.opacity(0.55)).frame(width: size * 0.045))
                .offset(y: -size * 0.47)
        }
        .frame(width: size, height: size * 1.12)
        .accessibilityLabel("Blink, o robô de LED")
    }

    private var eye: some View {
        Group {
            switch mood {
            case .happy:
                Circle()
                    .fill(BlinkTheme.orange)
                    .frame(width: size * 0.085)
            case .thinking:
                Capsule()
                    .fill(BlinkTheme.orange)
                    .frame(width: size * 0.09, height: size * 0.045)
            case .excited:
                Image(systemName: "star.fill")
                    .font(.system(size: size * 0.085))
                    .foregroundStyle(BlinkTheme.orange)
            }
        }
    }
}

