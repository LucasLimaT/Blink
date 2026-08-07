import SwiftUI

struct PostCardView: View {
    let post: Post
    let onOpen: () -> Void
    let onLike: () -> Void
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onOpen) {
                postContent
            }
            .buttonStyle(.plain)

            HStack(spacing: 22) {
                Button(action: onLike) {
                    actionIcon(
                        name: post.liked ? "heart.fill" : "heart",
                        tint: post.liked ? .blinkOrange : .blinkCharcoal.opacity(0.45),
                        count: post.likes
                    )
                }

                Button(action: onOpen) {
                    actionIcon(
                        name: "bubble.left",
                        tint: .blinkCharcoal.opacity(0.45),
                        count: post.comments
                    )
                }

                Spacer()

                Button(action: onSave) {
                    Image(systemName: post.saved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 15))
                        .foregroundColor(
                            post.saved ? .blinkCharcoal : .blinkCharcoal.opacity(0.45)
                        )
                }

                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 15))
                    .foregroundColor(.blinkCharcoal.opacity(0.45))
            }
            .buttonStyle(.plain)
            .padding(.bottom, 18)

            Divider()
        }
        .padding(.top, 18)
    }

    private var postContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 10) {
                if post.isTutor {
                    Image(MascotPose.blinkOn.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 38, height: 38)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    AvatarBadge(initials: post.initials)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(post.author)
                        .font(.system(size: 14, weight: .bold))
                    Text(post.time.uppercased())
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.blinkCharcoal.opacity(0.4))
                }

                Spacer(minLength: 8)
                CategoryTag(category: post.category)
            }
            .padding(.bottom, 10)

            Text(post.title)
                .font(.system(size: 15, weight: .bold))
                .padding(.bottom, 6)

            if post.hasPhoto {
                CircuitPhoto()
                    .padding(.bottom, 12)
            }

            Text(post.body)
                .font(.system(size: 14))
                .foregroundColor(.blinkCharcoal.opacity(0.70))
                .lineSpacing(3)
                .padding(.bottom, 12)
        }
    }

    private func actionIcon(
        name: String,
        tint: Color,
        count: Int
    ) -> some View {
        HStack(spacing: 6) {
            Image(systemName: name)
                .font(.system(size: 15))
                .foregroundColor(tint)
            Text("\(count)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.blinkCharcoal.opacity(0.55))
        }
    }
}

struct CircuitPhoto: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blinkSand)
                .frame(height: 200)
            VStack(spacing: 8) {
                Image(systemName: "photo")
                    .font(.system(size: 24))
                Text("FOTO DO CIRCUITO")
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundColor(.blinkCharcoal.opacity(0.45))
        }
    }
}
