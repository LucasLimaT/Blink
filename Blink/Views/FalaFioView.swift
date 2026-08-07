import SwiftUI

struct FalaFioView: View {
    @Binding var posts: [Post]
    @Binding var selectedTab: Int

    @State private var filter: PostCategory?
    @State private var composerOpen = false
    @State private var composerCategory: PostCategory = .duvida
    @State private var postText = ""
    @State private var selectedPostID: String?

    @StateObject private var viewModel = PostsViewModel()

    var visiblePosts: [Post] {
        if let filter {
            return posts.filter {
                $0.category == filter
            }
        }

        return posts
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    header

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            ComposerCard(
                                onTap: {
                                    composerOpen = true
                                },
                                onCamera: {
                                    selectedTab = 2
                                }
                            )
                            .padding(.top, 16)

                            ForEach(visiblePosts) { post in
                                PostCardView(
                                    post: post,
                                    onOpen: {
                                        selectedPostID = post.id
                                    },
                                    onLike: {
                                        toggleLike(post: post)
                                    },
                                    onSave: {
                                        toggleSave(post: post)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }

                ComposeFAB {
                    composerOpen = true
                }
                .padding(.trailing, 18)
                .padding(.bottom, 20)
            }
            .sheet(isPresented: $composerOpen) {
                ComposerSheet(
                    category: $composerCategory,
                    text: $postText,
                    publish: publishPost
                )
            }
            .navigationDestination(item: $selectedPostID) { postID in
                if let index = posts.firstIndex(where: {
                    $0.id == postID
                }) {
                    PostDetailView(post: $posts[index])
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("FalaFio")
                .font(.system(size: 22, weight: .heavy))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    filterButton(category: nil, label: "Tudo")

                    ForEach(PostCategory.allCases) { category in
                        filterButton(
                            category: category,
                            label: category.label
                        )
                    }
                }
            }

            Divider()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .background(Color.blinkSurface)
    }

    private func filterButton(
        category: PostCategory?,
        label: String
    ) -> some View {
        Button {
            filter = category
        } label: {
            VStack(spacing: 8) {
                Text(label.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(
                        filter == category
                            ? .blinkCharcoal
                            : .blinkCharcoal.opacity(0.45)
                    )
                Rectangle()
                    .fill(
                        filter == category
                            ? Color.blinkCharcoal
                            : Color.clear
                    )
                    .frame(height: 2)
            }
        }
        .buttonStyle(.plain)
    }

    private func toggleLike(post: Post) {
        guard let index = posts.firstIndex(where: {
            $0.id == post.id
        }) else {
            return
        }

        posts[index].liked.toggle()
        posts[index].likes += posts[index].liked ? 1 : -1
    }

    private func toggleSave(post: Post) {
        guard let index = posts.firstIndex(where: {
            $0.id == post.id
        }) else {
            return
        }

        posts[index].saved.toggle()
    }

    private func publishPost() {
        let body = postText.trimmingCharacters(in: .whitespacesAndNewlines)

        if body.isEmpty {
            return
        }

        let author = "Lucas Taveira"
        let title = postTitle(text: body)

        viewModel.cadastrarPosts(
            author: author,
            comments: [],
            contents: [title, body],
            tags: [composerCategory.label]
        )

        posts.insert(
            Post(
                id: UUID().uuidString,
                author: author,
                initials: "LT",
                time: "agora",
                category: composerCategory,
                isTutor: false,
                hasPhoto: false,
                title: title,
                body: body,
                likes: 0,
                comments: 0,
                liked: false,
                saved: false
            ),
            at: 0
        )

        postText = ""
        composerOpen = false
    }

    private func postTitle(text: String) -> String {
        let firstLine = text.split(whereSeparator: \.isNewline).first
        let title = firstLine.map(String.init) ?? text

        if title.count > 54 {
            return String(title.prefix(54)) + "…"
        }

        return title
    }
}
