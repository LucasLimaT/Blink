import SwiftUI

enum Tab {
    case trilha, bancada, falafio, blink
}

// Trilha

enum ModuleState: Equatable {
    case done, current, locked, chest
}

struct Module: Identifiable {
    let id: String
    let label: String
    var state: ModuleState
    let detail: String
    let topics: [String]
    let example: String
    let activity: String

    var statusLabel: String {
        switch state {
        case .done: return "Concluído"
        case .current: return "Etapa atual"
        case .locked: return "Bloqueado"
        case .chest: return "Recompensa"
        }
    }

}

// FalaFio

enum PostCategory: String, CaseIterable, Identifiable, Equatable {
    case duvida, problema, conquista, dica

    var id: String { rawValue }

    var label: String {
        switch self {
        case .duvida: return "Dúvida"
        case .problema: return "Problema"
        case .conquista: return "Conquista"
        case .dica: return "Dica"
        }
    }

    var color: Color {
        switch self {
        case .duvida: return .blinkBlue
        case .problema: return .blinkRed
        case .conquista: return .blinkOrange
        case .dica: return .blinkCharcoal
        }
    }

    var symbol: String {
        switch self {
        case .duvida: return "questionmark.bubble"
        case .problema: return "exclamationmark.triangle"
        case .conquista: return "checkmark.seal"
        case .dica: return "screwdriver"
        }
    }
}

struct Post: Identifiable {
    let id: String
    let author: String
    let initials: String
    let time: String
    let category: PostCategory
    let isTutor: Bool
    let hasPhoto: Bool
    let title: String
    let body: String
    var likes: Int
    var comments: Int
    var liked: Bool
    var saved: Bool
}

// Blink

struct BlinkChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let fromBot: Bool
}

struct Suggestion: Identifiable {
    let id = UUID()
    let label: String
    let reply: String
}

// Bancada

struct InventoryItem: Identifiable {
    let id = UUID()
    let name: String
    var quantity: Int
}

struct ProjectItem: Identifiable {
    let id: String
    let name: String
    var progress: Int
    var nextStep: String
}

struct SavedItem: Identifiable {
    let id: String
    let title: String
    let author: String
}
