import SwiftUI

struct ModuleDetailView: View {
    @Binding var module: Module
    let complete: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                moduleHeader

                if !module.topics.isEmpty {
                    sectionTitle(text: "O QUE VOCÊ VAI APRENDER")

                    ForEach(module.topics.indices, id: \.self) { index in
                        topicRow(
                            number: index + 1,
                            text: module.topics[index]
                        )
                    }
                }

                sectionTitle(text: "EXEMPLO")
                informationCard(
                    icon: "lightbulb",
                    text: module.example
                )

                sectionTitle(
                    text: module.state == .chest
                        ? "COMO ABRIR"
                        : "PRATIQUE"
                )
                informationCard(
                    icon: "wrench.and.screwdriver",
                    text: module.activity
                )

                moduleAction
                    .padding(.top, 24)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(Color.blinkSurface)
        .navigationTitle("Detalhes da etapa")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var moduleHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(module.statusLabel.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.72))

                Spacer()

                Image(systemName: headerIcon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }

            Text(module.label)
                .font(.system(size: 24, weight: .heavy))
                .foregroundColor(.white)

            Text(module.detail)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.80))
                .lineSpacing(3)
        }
        .padding(20)
        .background(Color.blinkOrange)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.top, 20)
    }

    private var headerIcon: String {
        switch module.state {
        case .done:
            return "checkmark.circle.fill"
        case .current:
            return "bolt.fill"
        case .locked:
            return "lock.fill"
        case .chest:
            return "trophy.fill"
        }
    }

    private func sectionTitle(text: String) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.blinkCharcoal.opacity(0.45))
            .padding(.top, 24)
            .padding(.bottom, 12)
    }

    private func topicRow(number: Int, text: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.blinkSand)
                    .frame(width: 34, height: 34)

                Text("\(number)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.blinkOrange)
            }

            Text(text)
                .font(.system(size: 14, weight: .semibold))

            Spacer()
        }
        .padding(.vertical, 7)
    }

    private func informationCard(
        icon: String,
        text: String
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.blinkOrange)

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.blinkCharcoal.opacity(0.70))
                .lineSpacing(3)

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color.blinkSand)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var moduleAction: some View {
        Group {
            if module.state == .current {
                PrimaryButton(title: "Concluir etapa", action: complete)
            } else if module.state == .done {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blinkOrange)
                    Text("Etapa concluída")
                        .font(.system(size: 14, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.blinkSand)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}
