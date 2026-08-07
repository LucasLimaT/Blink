import SwiftUI

struct TrailNode: View {
    let module: Module
    let action: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            if module.state == .current {
                Text("COMEÇAR")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blinkCharcoal)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button(action: action) {
                node
            }
            .buttonStyle(.plain)

            Text(module.label.uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(labelColor)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 118)
        }
    }

    private var node: some View {
        ZStack {
            if module.state == .current {
                Circle()
                    .fill(Color.blinkCharcoal)
                    .frame(width: 82, height: 82)
                Circle()
                    .fill(Color.blinkOrange)
                    .frame(width: 74, height: 74)
            } else {
                Circle()
                    .fill(nodeColor)
                    .frame(width: 64, height: 64)
            }

            icon
        }
        .shadow(radius: 2)
    }

    private var nodeColor: Color {
        if module.state == .locked || module.state == .chest {
            return .blinkSand
        }
        return .blinkOrange
    }

    private var labelColor: Color {
        if module.state == .locked || module.state == .chest {
            return .blinkCharcoal.opacity(0.35)
        }
        return .blinkCharcoal.opacity(0.65)
    }

    @ViewBuilder
    private var icon: some View {
        switch module.state {
        case .done:
            Image(systemName: "checkmark")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
        case .current:
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 26, weight: .medium))
                .foregroundColor(.white)
        case .locked:
            Image(systemName: "lock")
                .font(.system(size: 19, weight: .medium))
                .foregroundColor(.blinkCharcoal.opacity(0.35))
        case .chest:
            Image(systemName: "trophy")
                .font(.system(size: 21, weight: .medium))
                .foregroundColor(.blinkCharcoal.opacity(0.4))
        }
    }
}
