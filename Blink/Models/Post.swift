struct PostGet: Codable {
    let _id: String
    let _rev: String
    let author: String
    let comments: [Comment]
    let contents: [String]
    let tags: [String]
}

struct PostPost: Codable {
    let author: String
    let comments: [Comment]
    let contents: [String]
    let tags: [String]
}

struct Comment: Codable {
    let author: String
    let content: String
}
