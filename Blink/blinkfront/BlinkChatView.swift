import SwiftUI

struct BlinkChatView: View {
    @State private var input = ""
    @State private var messages: [ChatMessage] = [
        ChatMessage(text: "Oi, Lucas! Eu sou o Blink ⚡ Posso explicar eletrônica, ajudar em uma dúvida ou pensar em um projeto com você.", sender: .blink, time: "20:32")
    ]

    private let suggestions = [
        "Como funciona um resistor?",
        "Quero uma ideia de projeto",
        "Explique a Lei de Ohm"
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 14) {
                            mascotHeader
                            suggestionRow
                            ForEach(messages) { message in
                                messageBubble(message)
                                    .id(message.id)
                            }
                        }
                        .padding(.horizontal, BlinkTheme.horizontalPadding)
                        .padding(.vertical, 16)
                    }
                    .onChange(of: messages.count) { _ in
                        if let last = messages.last {
                            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                        }
                    }
                }
                composer
            }
            .background(BlinkTheme.surface)
            .navigationTitle("Blink")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 5) {
                        Circle().fill(.green).frame(width: 8, height: 8)
                        Text("online").font(.system(size: 12, weight: .semibold)).foregroundStyle(BlinkTheme.muted)
                    }
                }
            }
        }
    }

    private var mascotHeader: some View {
        VStack(spacing: 8) {
            BlinkMascot(size: 88, mood: .happy)
            Text("Seu parceiro de bancada")
                .font(.system(size: 15, weight: .bold))
            Text("Pergunte sem medo — errar também faz parte do circuito.")
                .font(.system(size: 12))
                .foregroundStyle(BlinkTheme.muted)
        }
        .padding(.bottom, 4)
    }

    private var suggestionRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button { send(suggestion) } label: {
                        Text(suggestion)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(BlinkTheme.orangeDark)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 10)
                            .background(BlinkTheme.orangeSoft)
                            .clipShape(Capsule())
                            .overlay { Capsule().stroke(BlinkTheme.orange.opacity(0.25)) }
                    }
                }
            }
        }
    }

    private func messageBubble(_ message: ChatMessage) -> some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.sender == .user { Spacer(minLength: 50) }

            if message.sender == .blink {
                BlinkMascot(size: 34, mood: .happy)
            }

            VStack(alignment: message.sender == .user ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.system(size: 14))
                    .foregroundStyle(message.sender == .user ? .white : BlinkTheme.ink)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background(message.sender == .user ? BlinkTheme.ink : .white)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay {
                        if message.sender == .blink {
                            RoundedRectangle(cornerRadius: 18).stroke(BlinkTheme.line)
                        }
                    }
                Text(message.time)
                    .font(.system(size: 9))
                    .foregroundStyle(BlinkTheme.muted)
            }

            if message.sender == .blink { Spacer(minLength: 44) }
        }
    }

    private var composer: some View {
        HStack(spacing: 10) {
            Button {} label: {
                Image(systemName: "plus")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(BlinkTheme.orange)
            }
            TextField("Pergunte ao Blink...", text: $input, axis: .vertical)
                .lineLimit(1...4)
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .background(BlinkTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            Button { send(input) } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? BlinkTheme.line : BlinkTheme.orange)
                    .clipShape(Circle())
            }
            .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.white)
        .overlay(alignment: .top) { Divider() }
    }

    private func send(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        messages.append(ChatMessage(text: trimmed, sender: .user, time: "agora"))
        input = ""

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
            messages.append(
                ChatMessage(
                    text: "Boa pergunta! Pense no resistor como uma torneira: ele limita a corrente para proteger os componentes. Quer que eu monte um exemplo com valores reais?",
                    sender: .blink,
                    time: "agora"
                )
            )
        }
    }
}

