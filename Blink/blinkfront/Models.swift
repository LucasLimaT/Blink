import SwiftUI

struct LearningStep: Identifiable, Hashable {
    enum Status: Hashable {
        case completed, current, locked
    }

    let id: Int
    let title: String
    let subtitle: String
    let icon: String
    let status: Status
    let xp: Int
    let duration: String
    let difficulty: String
    let summary: String
    let objectives: [String]
    let components: [String]
    let challenge: String
}

struct CommunityPost: Identifiable {
    let id: UUID
    let author: String
    let initials: String
    let role: String
    let time: String
    let title: String
    let body: String
    let tags: [String]
    var likes: Int
    var comments: [PostComment]
    var isLiked: Bool
    let featuredColor: Color
}

struct PostComment: Identifiable {
    let id = UUID()
    let author: String
    let initials: String
    let time: String
    let text: String
    var likes: Int
}

struct ChatMessage: Identifiable {
    enum Sender {
        case user, blink
    }

    let id = UUID()
    let text: String
    let sender: Sender
    let time: String
}

struct DetectedComponent: Identifiable {
    let id = UUID()
    let name: String
    let detail: String
    let icon: String
    let confidence: Int
}
