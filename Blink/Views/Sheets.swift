import SwiftUI

struct ComposerSheet: View {
    @Binding var category: PostCategory
    @Binding var text: String

    let publish: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Nova publicação")
                .font(.system(size: 18, weight: .heavy))

            HStack(spacing: 8) {
                ForEach(PostCategory.allCases) { option in
                    Button {
                        category = option
                    } label: {
                        Text(option.label.uppercased())
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(option.color)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(
                                category == option
                                    ? option.color.opacity(0.12)
                                    : Color.blinkSand.opacity(0.55)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }

            TextEditor(text: $text)
                .font(.system(size: 14))
                .scrollContentBackground(.hidden)
                .padding(10)
                .frame(height: 96)
                .background(Color.blinkSand.opacity(0.45))
                .clipShape(RoundedRectangle(cornerRadius: 16))

            if text.isEmpty {
                Text("Conte o que você precisa antes de publicar.")
                    .font(.system(size: 12))
                    .foregroundColor(.blinkCharcoal.opacity(0.45))
            }

            PrimaryButton(title: "Publicar", action: publish)
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .presentationDetents([.height(360)])
    }
}
