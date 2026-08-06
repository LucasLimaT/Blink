import SwiftUI
import Combine

final class CommunityStore: ObservableObject {
    @Published var posts: [CommunityPost] = CommunityStore.samples

    func toggleLike(_ postID: UUID) {
        guard let index = posts.firstIndex(where: { $0.id == postID }) else { return }
        posts[index].isLiked.toggle()
        posts[index].likes += posts[index].isLiked ? 1 : -1
    }

    func addPost(title: String, body: String, tag: String) {
        let post = CommunityPost(
            id: UUID(),
            author: "Lucas Taveira",
            initials: "LT",
            role: "Aprendiz de eletrônica",
            time: "agora",
            title: title,
            body: body,
            tags: [tag],
            likes: 0,
            comments: [],
            isLiked: false,
            featuredColor: BlinkTheme.orange
        )
        posts.insert(post, at: 0)
    }

    func addComment(to postID: UUID, text: String) {
        guard let index = posts.firstIndex(where: { $0.id == postID }) else { return }
        posts[index].comments.append(
            PostComment(author: "Lucas Taveira", initials: "LT", time: "agora", text: text, likes: 0)
        )
    }

    static let samples: [CommunityPost] = [
        CommunityPost(
            id: UUID(),
            author: "Ana Martins",
            initials: "AM",
            role: "Nível 8 · Maker",
            time: "há 12 min",
            title: "Meu primeiro semáforo com Arduino 🚦",
            body: "Terminei o projeto da trilha hoje! Troquei o tempo do LED amarelo e adicionei um botão para pedestres. O que vocês melhorariam?",
            tags: ["Arduino", "Projeto"],
            likes: 48,
            comments: [
                PostComment(author: "Rafael Souza", initials: "RS", time: "há 6 min", text: "Ficou muito bom! Um buzzer para acessibilidade seria uma ótima próxima etapa.", likes: 7),
                PostComment(author: "Bia Campos", initials: "BC", time: "há 2 min", text: "Você pode compartilhar como organizou os fios? Estou fazendo o mesmo projeto.", likes: 3)
            ],
            isLiked: false,
            featuredColor: BlinkTheme.orange
        ),
        CommunityPost(
            id: UUID(),
            author: "Pedro Lima",
            initials: "PL",
            role: "Nível 5 · Curioso",
            time: "há 1 h",
            title: "Dúvida: resistor para LED azul",
            body: "Tenho uma fonte de 5 V e um LED azul de 3,2 V. O cálculo deu 90 Ω. Posso usar o resistor de 100 Ω que tenho aqui?",
            tags: ["Dúvida", "Componentes"],
            likes: 21,
            comments: [
                PostComment(author: "Marina Alves", initials: "MA", time: "há 45 min", text: "Pode sim. Com 100 Ω a corrente fica um pouco menor e o LED trabalha com mais segurança.", likes: 12)
            ],
            isLiked: true,
            featuredColor: Color.blue
        ),
        CommunityPost(
            id: UUID(),
            author: "Marina Alves",
            initials: "MA",
            role: "Nível 12 · Inventora",
            time: "ontem",
            title: "Sensor de luz automático finalizado",
            body: "Usei um LDR, transistor e alguns resistores que estavam parados. A câmera do Blink sugeriu a luminária e funcionou de primeira!",
            tags: ["Conquista", "Sensor"],
            likes: 93,
            comments: [],
            isLiked: false,
            featuredColor: Color.purple
        )
    ]
}

