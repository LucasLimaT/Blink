import SwiftUI

struct ComposerCard: View {
    let onTap: () -> Void
    let onCamera: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    AvatarBadge(initials: "LM", filled: true)
                    Text("Conte o que você precisa…")
                        .font(.system(size: 14))
                        .foregroundColor(.blinkCharcoal.opacity(0.45))
                    Spacer(minLength: 8)
                }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)

            Button(action: onCamera) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blinkOrange)
                        .frame(width: 38, height: 38)
                    Image(systemName: "camera")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, 14)
        .padding(.trailing, 12)
        .padding(.vertical, 12)
        .background(Color.blinkSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 1)
    }
}

struct ComposeFAB: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.blinkOrange)
                    .frame(width: 58, height: 58)
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 21, weight: .medium))
                    .foregroundColor(.white)
            }
            .shadow(radius: 5)
        }
        .buttonStyle(.plain)
    }
}
