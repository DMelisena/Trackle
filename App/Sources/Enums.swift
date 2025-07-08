import SwiftUI

// MARK: - Data Models

struct MathQuestion: Identifiable, Codable {
    let id = UUID()
    var chapter: MathChapter

    var question: String
    var options: [String]
    var correctAnswer: Int
}

enum MathChapter: String, CaseIterable, Codable {
    case algebra = "Algebra"
    case geometry = "Geometry"
    case calculus = "Calculus"
    case statistics = "Statistics"
    case trigonometry = "Trigonometry"

    // Define chapter dependencies
    var prerequisites: [MathChapter] {
        switch self {
        case .algebra:
            return [] // No prerequisites - starting chapter
        case .geometry:
            return [.algebra]
        case .calculus:
            return [.algebra]
        case .statistics:
            return [.algebra]
        case .trigonometry:
            return [.geometry]
        }
    }

    // Define what chapters this chapter unlocks
    var unlocks: [MathChapter] {
        switch self {
        case .algebra:
            return [.geometry, .calculus, .statistics]
        case .geometry:
            return [.trigonometry]
        case .calculus, .statistics, .trigonometry:
            return [] // These don't unlock additional chapters
        }
    }

    // Check if this chapter is unlocked based on completed chapters
    func isUnlocked(completedChapters: Set<MathChapter>) -> Bool {
        return prerequisites.allSatisfy { completedChapters.contains($0) }
    }
}

struct QuizResult: Identifiable, Codable {
    let id = UUID()
    var userId: String
    var chapter: MathChapter

    var score: Int
    var totalQuestions: Int
    var date: Date
    var timeSpent: TimeInterval
}

struct QuizSession {
    var questions: [MathQuestion]
    var currentQuestionIndex: Int = 0
    var selectedAnswers: [Int] = []
    var startTime: Date = .init()
    var score: Int = 0
}
