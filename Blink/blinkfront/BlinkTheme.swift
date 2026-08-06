import SwiftUI

enum BlinkTheme {
    static let orange = Color(red: 1.00, green: 0.39, blue: 0.08)
    static let primary = orange
    static let orangeDark = Color(red: 0.86, green: 0.25, blue: 0.02)
    static let orangeSoft = Color(red: 1.00, green: 0.93, blue: 0.88)
    static let ink = Color(red: 0.07, green: 0.07, blue: 0.08)
    static let graphite = Color(red: 0.25, green: 0.25, blue: 0.28)
    static let muted = Color(red: 0.45, green: 0.45, blue: 0.49)
    static let line = Color(red: 0.90, green: 0.90, blue: 0.92)
    static let surface = Color(red: 0.97, green: 0.97, blue: 0.98)
    static let white = Color.white

    static let cardRadius: CGFloat = 22
    static let horizontalPadding: CGFloat = 20
}

extension View {
    func blinkCard(padding: CGFloat = 18) -> some View {
        self
            .padding(padding)
            .background(BlinkTheme.white)
            .clipShape(RoundedRectangle(cornerRadius: BlinkTheme.cardRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: BlinkTheme.cardRadius, style: .continuous)
                    .stroke(BlinkTheme.line, lineWidth: 1)
            }
    }

    func blinkShadow() -> some View {
        shadow(color: BlinkTheme.ink.opacity(0.08), radius: 18, y: 8)
    }
}

struct OrangeButtonStyle: ButtonStyle {
    var compact = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: compact ? 14 : 16, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, compact ? 16 : 20)
            .frame(minHeight: compact ? 42 : 54)
            .background(configuration.isPressed ? BlinkTheme.orangeDark : BlinkTheme.orange)
            .clipShape(RoundedRectangle(cornerRadius: compact ? 14 : 18, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
