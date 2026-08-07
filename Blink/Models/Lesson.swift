struct LessonGet: Codable {
    let _id: String
    let _rev: String
    let title: String
    let type: String
    let contents: [String]
    let exercises: [Exercise]?
}

struct LessonPost: Codable {
    let title: String
    let type: String
    let contents: [String]
    let exercises: [Exercise]?
}

struct Exercise: Codable {
    let question: String
    let alternatives: [String]
    let response: String
}
