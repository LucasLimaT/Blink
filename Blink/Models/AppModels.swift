import Foundation

struct ElectronicComponent: Identifiable {
    let id: String
    let name: String
    let detail: String
    let photoURL: String?
    let icon: String
}

struct ProjectSuggestion {
    let title: String
    let description: String
    let url: String?
}

struct DetectedComponent: Identifiable {
    let component: ElectronicComponent
    var confidence: Int

    var id: String {
        component.id
    }
}
