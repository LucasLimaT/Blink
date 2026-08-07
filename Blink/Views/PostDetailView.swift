import SwiftUI

struct PostDetailView: View {
    @Binding var post: Post

    var comments: [Comment] {
        FrontendMocks.comments(postID: post.id)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                authorHeader

                Text(post.title)
                    .font(.system(size: 22, weight: .heavy))
                    .padding(.top, 18)

                if post.hasPhoto {
                    CircuitPhoto()
                        .padding(.top, 16)
                }

                Text(post.body)
                    .font(.system(size: 15))
                    .foregroundColor(.blinkCharcoal.opacity(0.70))
                    .lineSpacing(4)
                    .padding(.top, 14)

                actions
                    .padding(.vertical, 18)

                Divider()

                Text("COMENTÁRIOS EM DESTAQUE")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.blinkCharcoal.opacity(0.45))
                    .padding(.top, 20)
                    .padding(.bottom, 4)

                if comments.isEmpty {
                    Text("Ainda não há comentários nesta publicação.")
                        .font(.system(size: 14))
                        .foregroundColor(.blinkCharcoal.opacity(0.45))
                        .padding(.vertical, 20)
                } else {
                    ForEach(comments.indices, id: \.self) { index in
                        commentRow(comment: comments[index])
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(Color.blinkSurface)
        .navigationTitle("Publicação")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var authorHeader: some View {
        HStack(alignment: .top, spacing: 10) {
            if post.isTutor {
                Image(MascotPose.blinkOn.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 42, height: 42)
            } else {
                AvatarBadge(initials: post.initials)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(post.author)
                    .font(.system(size: 14, weight: .bold))
                Text(post.time.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.blinkCharcoal.opacity(0.40))
            }

            Spacer()
            CategoryTag(category: post.category)
        }
        .padding(.top, 18)
    }

    private var actions: some View {
        HStack(spacing: 24) {
            Button {
                post.liked.toggle()
                post.likes += post.liked ? 1 : -1
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: post.liked ? "heart.fill" : "heart")
                    Text("\(post.likes)")
                }
                .foregroundColor(
                    post.liked
                        ? .blinkOrange
                        : .blinkCharcoal.opacity(0.45)
                )
            }
            

            HStack(spacing: 6) {
                Image(systemName: "bubble.left")
                Text("\(post.comments)")
            }
            .foregroundColor(.blinkCharcoal.opacity(0.45))

            Spacer()

            Button {
                post.saved.toggle()
            } label: {
                Image(systemName: post.saved ? "bookmark.fill" : "bookmark")
                    .foregroundColor(
                        post.saved
                            ? .blinkCharcoal
                            : .blinkCharcoal.opacity(0.45)
                    )
            }
        }
        .font(.system(size: 15, weight: .semibold))
        .buttonStyle(.plain)
    }

    private func commentRow(comment: Comment) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 10) {
                AvatarBadge(initials: initials(author: comment.author))

                VStack(alignment: .leading, spacing: 5) {
                    Text(comment.author)
                        .font(.system(size: 13, weight: .bold))

                    Text(comment.content)
                        .font(.system(size: 14))
                        .foregroundColor(.blinkCharcoal.opacity(0.70))
                        .lineSpacing(3)
                }

                Spacer(minLength: 0)
            }
            .padding(.vertical, 14)

            Divider()
        }
    }

    private func initials(author: String) -> String {
        let names = author.split(separator: " ").prefix(2)
        return names.map {
            String($0.prefix(1))
        }.joined()
    }
}
