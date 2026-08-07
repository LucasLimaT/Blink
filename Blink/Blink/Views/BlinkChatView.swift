import SwiftUI

struct BlinkChatView: View {
    @Binding var messages: [BlinkChatMessage]
    @State private var draft = ""

    let suggestions = AppStore.suggestions

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    intro
                    suggestionRow

                    VStack(spacing: 12) {
                        ForEach(messages) { message in
                            bubble(message: message)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }

            composer
        }
    }

    private var header: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image("blink1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 24)
                Circle()
                    .fill(Color.blinkOrange)
                    .frame(width: 7, height: 7)
                Text("ONLINE")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.blinkCharcoal.opacity(0.45))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            Divider()
        }
    }

    private var intro: some View {
        VStack(spacing: 4) {
            MascotView(pose: .wave)
                .frame(width: 76, height: 76)
                .padding(.bottom, 14)
            Text("Seu parceiro de bancada")
                .font(.system(size: 19, weight: .heavy))
            Text("Pergunte sobre componentes, circuitos ou peça ideias de projeto")
                .font(.system(size: 14))
                .foregroundColor(.blinkCharcoal.opacity(0.45))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }

    private var suggestionRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(suggestions) { suggestion in
                    Button {
                        ask(suggestion: suggestion)
                    } label: {
                        Text(suggestion.label)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.blinkCharcoal)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            .background(Color.blinkSurface)
                            .clipShape(Capsule())
                            .shadow(radius: 1)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 12)
    }

    private func bubble(message: BlinkChatMessage) -> some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.fromBot {
                Image(MascotPose.blinkOn.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Spacer(minLength: 40)
            }

            Text(message.text)
                .font(.system(size: 14))
                .foregroundColor(message.fromBot ? .blinkCharcoal : .white)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    message.fromBot ? Color.blinkSand : Color.blinkOrange
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(
                    maxWidth: 250,
                    alignment: message.fromBot ? .leading : .trailing
                )

            if message.fromBot {
                Spacer(minLength: 40)
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: message.fromBot ? .leading : .trailing
        )
    }

    private var composer: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 10) {
                TextField("Escreva para o Blink…", text: $draft)
                    .font(.system(size: 14))
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        send()
                    }

                Button {
                    send()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.blinkOrange)
                            .frame(width: 40, height: 40)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.blinkSurface)
        }
    }

    private func ask(suggestion: Suggestion) {
        messages.append(
            BlinkChatMessage(text: suggestion.label, fromBot: false)
        )
        reply(text: suggestion.reply)
    }

    private func send() {
        let message = draft.trimmingCharacters(in: .whitespacesAndNewlines)

        if message.isEmpty {
            return
        }

        draft = ""
        messages.append(
            BlinkChatMessage(text: message, fromBot: false)
        )
        reply(text: MockData.chatReply(message: message))
    }

    private func reply(text: String) {
        messages.append(
            BlinkChatMessage(text: text, fromBot: true)
        )
    }
}
