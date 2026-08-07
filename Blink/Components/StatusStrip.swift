import SwiftUI

struct StatusStrip: View {
    var xp = 1_240
    var initials = "LM"

    var body: some View {
        HStack {
            XPPill(value: xp)
            Spacer()
            AvatarBadge(initials: initials, filled: true)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
}

struct XPPill: View {
    let value: Int

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.blinkOrange)
            Text("\(value)")
                .font(.system(size: 14, weight: .heavy))
            Text("XP")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.blinkCharcoal.opacity(0.45))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.blinkSand)
        .clipShape(Capsule())
    }
}

struct AvatarBadge: View {
    let initials: String
    var filled = false

    var body: some View {
        ZStack {
            Circle()
                .fill(filled ? Color.blinkCharcoal : Color.blinkSand)
                .frame(width: 38, height: 38)
            Text(initials)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(filled ? .white : .blinkCharcoal)
        }
    }
}

struct ThinProgressBar: View {
    let value: Int
    var tint = Color.blinkOrange

    var body: some View {
        ProgressView(value: Double(value), total: 100)
            .tint(tint)
    }
}
