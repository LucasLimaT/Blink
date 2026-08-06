import SwiftUI

struct CommunityView: View {
    @EnvironmentObject private var store: CommunityStore
    @State private var selectedFilter = "Para você"
    @State private var showComposer = false

    private let filters = ["Para você", "Projetos", "Dúvidas", "Conquistas"]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    communityHero
                    filtersRow
                    ForEach(filteredPosts) { post in
                        NavigationLink(value: post.id) {
                            PostCard(post: post) {
                                store.toggleLike(post.id)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, BlinkTheme.horizontalPadding)
                .padding(.bottom, 28)
            }
            .background(BlinkTheme.surface)
            .navigationTitle("Comunidade")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "person.3.fill").foregroundStyle(BlinkTheme.orange)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showComposer = true } label: {
                        Label("Postar", systemImage: "square.and.pencil")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(BlinkTheme.orange)
                            .clipShape(Capsule())
                    }
                }
            }
            .navigationDestination(for: UUID.self) { postID in
                PostDetailView(postID: postID)
            }
            .sheet(isPresented: $showComposer) {
                NewPostView()
            }
        }
    }

    private var filteredPosts: [CommunityPost] {
        switch selectedFilter {
        case "Projetos":
            return store.posts.filter { $0.tags.contains("Projeto") }
        case "Dúvidas":
            return store.posts.filter { $0.tags.contains("Dúvida") }
        case "Conquistas":
            return store.posts.filter { $0.tags.contains("Conquista") }
        default:
            return store.posts
        }
    }

    private var communityHero: some View {
        HStack(spacing: 14) {
            BlinkMascot(size: 66, mood: .happy)
            VStack(alignment: .leading, spacing: 4) {
                Text("Feito é melhor que perfeito.")
                    .font(.system(size: 17, weight: .bold))
                Text("Mostre seu projeto, tire dúvidas e ajude outros makers.")
                    .font(.system(size: 13))
                    .foregroundStyle(BlinkTheme.muted)
            }
            Spacer()
        }
        .blinkCard(padding: 14)
        .padding(.top, 8)
    }

    private var filtersRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 9) {
                ForEach(filters, id: \.self) { filter in
                    Button {
                        selectedFilter = filter
                    } label: {
                        Text(filter)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(selectedFilter == filter ? .white : BlinkTheme.graphite)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(selectedFilter == filter ? BlinkTheme.ink : .white)
                            .clipShape(Capsule())
                            .overlay { Capsule().stroke(selectedFilter == filter ? .clear : BlinkTheme.line) }
                    }
                }
            }
        }
    }
}

private struct PostCard: View {
    let post: CommunityPost
    let likeAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            authorHeader
            VStack(alignment: .leading, spacing: 7) {
                Text(post.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(BlinkTheme.ink)
                Text(post.body)
                    .font(.system(size: 14))
                    .foregroundStyle(BlinkTheme.graphite)
                    .lineSpacing(3)
                    .lineLimit(4)
            }
            tags
            Divider()
            actions
        }
        .blinkCard()
    }

    private var authorHeader: some View {
        HStack(spacing: 11) {
            Text(post.initials)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(post.featuredColor)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(post.author).font(.system(size: 14, weight: .bold)).foregroundStyle(BlinkTheme.ink)
                Text("\(post.role) · \(post.time)").font(.system(size: 11)).foregroundStyle(BlinkTheme.muted)
            }
            Spacer()
            Image(systemName: "ellipsis").foregroundStyle(BlinkTheme.muted)
        }
    }

    private var tags: some View {
        HStack {
            ForEach(post.tags, id: \.self) { tag in
                Text("#\(tag)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(BlinkTheme.orangeDark)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(BlinkTheme.orangeSoft)
                    .clipShape(Capsule())
            }
        }
    }

    private var actions: some View {
        HStack(spacing: 24) {
            Button(action: likeAction) {
                Label("\(post.likes)", systemImage: post.isLiked ? "heart.fill" : "heart")
                    .foregroundStyle(post.isLiked ? BlinkTheme.orange : BlinkTheme.muted)
            }
            .buttonStyle(.plain)
            Label("\(post.comments.count)", systemImage: "bubble.left")
            Spacer()
            Image(systemName: "bookmark")
            Image(systemName: "square.and.arrow.up")
        }
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(BlinkTheme.muted)
    }
}

struct NewPostView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: CommunityStore
    @State private var title = ""
    @State private var bodyText = ""
    @State private var selectedTag = "Projeto"

    private let tags = ["Projeto", "Dúvida", "Conquista", "Componentes"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Sobre o que você quer falar?") {
                    TextField("Título do post", text: $title)
                    TextField("Conte os detalhes para a comunidade...", text: $bodyText, axis: .vertical)
                        .lineLimit(6...10)
                }
                Section("Categoria") {
                    Picker("Categoria", selection: $selectedTag) {
                        ForEach(tags, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                }
                Section {
                    Button {} label: {
                        Label("Adicionar foto do projeto", systemImage: "photo.badge.plus")
                    }
                    Button {} label: {
                        Label("Adicionar componentes", systemImage: "cpu")
                    }
                }
            }
            .navigationTitle("Novo post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Publicar") {
                        store.addPost(title: title, body: bodyText, tag: selectedTag)
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || bodyText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

struct PostDetailView: View {
    @EnvironmentObject private var store: CommunityStore
    let postID: UUID
    @State private var commentText = ""

    private var post: CommunityPost? {
        store.posts.first(where: { $0.id == postID })
    }

    var body: some View {
        VStack(spacing: 0) {
            if let post {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        PostCard(post: post) { store.toggleLike(post.id) }
                        Text("Comentários · \(post.comments.count)")
                            .font(.system(size: 18, weight: .bold))
                        if post.comments.isEmpty {
                            emptyComments
                        } else {
                            ForEach(post.comments) { comment in
                                CommentRow(comment: comment)
                            }
                        }
                    }
                    .padding(BlinkTheme.horizontalPadding)
                }
                commentComposer
            }
        }
        .background(BlinkTheme.surface)
        .navigationTitle("Publicação")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var emptyComments: some View {
        VStack(spacing: 8) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 30))
                .foregroundStyle(BlinkTheme.orange)
            Text("Seja o primeiro a comentar")
                .font(.system(size: 14, weight: .bold))
            Text("Uma boa conversa pode acender uma nova ideia.")
                .font(.system(size: 12))
                .foregroundStyle(BlinkTheme.muted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
    }

    private var commentComposer: some View {
        HStack(spacing: 10) {
            TextField("Escreva um comentário...", text: $commentText)
                .padding(.horizontal, 14)
                .frame(height: 44)
                .background(BlinkTheme.surface)
                .clipShape(Capsule())
            Button {
                let text = commentText.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !text.isEmpty else { return }
                store.addComment(to: postID, text: text)
                commentText = ""
            } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(BlinkTheme.orange)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.white)
        .overlay(alignment: .top) { Divider() }
    }
}

private struct CommentRow: View {
    let comment: PostComment

    var body: some View {
        HStack(alignment: .top, spacing: 11) {
            Text(comment.initials)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(BlinkTheme.ink)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text(comment.author).font(.system(size: 13, weight: .bold))
                    Text("· \(comment.time)").font(.system(size: 11)).foregroundStyle(BlinkTheme.muted)
                }
                Text(comment.text)
                    .font(.system(size: 13))
                    .foregroundStyle(BlinkTheme.graphite)
                    .lineSpacing(2)
                HStack(spacing: 16) {
                    Label("\(comment.likes)", systemImage: "heart")
                    Text("Responder")
                }
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(BlinkTheme.muted)
            }
            Spacer()
        }
        .blinkCard(padding: 14)
    }
}
