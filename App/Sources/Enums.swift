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
