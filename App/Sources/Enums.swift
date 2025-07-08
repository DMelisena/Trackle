import SwiftUI

// MARK: - Data Models

struct MathQuestion: Identifiable, Codable {
    let id = UUID()
    var chapter: MathChapter
    var difficulty: QuestionDifficulty?
    var imageName: String?
    var question: String
    var options: [String]
    var correctAnswer: Int

    // Custom coding keys to handle the JSON structure
    enum CodingKeys: String, CodingKey {
        case chapter, difficulty, imageName, question, options, correctAnswer
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Handle chapter - try string first, then enum
        if let chapterString = try? container.decode(String.self, forKey: .chapter) {
            chapter = MathChapter(rawValue: chapterString) ?? .algebra
        } else {
            chapter = try container.decode(MathChapter.self, forKey: .chapter)
        }

        // Handle optional difficulty
        if let difficultyString = try? container.decode(String.self, forKey: .difficulty) {
            difficulty = QuestionDifficulty(rawValue: difficultyString)
        } else {
            difficulty = nil
        }

        // Handle optional imageName
        imageName = try? container.decode(String.self, forKey: .imageName)

        // Handle required fields
        question = try container.decode(String.self, forKey: .question)
        options = try container.decode([String].self, forKey: .options)
        correctAnswer = try container.decode(Int.self, forKey: .correctAnswer)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chapter.rawValue, forKey: .chapter)
        try container.encodeIfPresent(difficulty?.rawValue, forKey: .difficulty)
        try container.encodeIfPresent(imageName, forKey: .imageName)
        try container.encode(question, forKey: .question)
        try container.encode(options, forKey: .options)
        try container.encode(correctAnswer, forKey: .correctAnswer)
    }

    // Manual initializer
    init(chapter: MathChapter, difficulty: QuestionDifficulty? = nil, imageName: String? = nil, question: String, options: [String], correctAnswer: Int) {
        self.chapter = chapter
        self.difficulty = difficulty
        self.imageName = imageName
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
    }
}

enum QuestionDifficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var color: Color {
        switch self {
        case .easy:
            return .green
        case .medium:
            return .yellow
        case .hard:
            return .red
        }
    }
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

    // Chapter icon
    var icon: String {
        switch self {
        case .algebra:
            return "x.squareroot"
        case .geometry:
            return "triangle"
        case .calculus:
            return "function"
        case .statistics:
            return "chart.bar"
        case .trigonometry:
            return "waveform"
        }
    }

    // Chapter color
    var color: Color {
        switch self {
        case .algebra:
            return .blue
        case .geometry:
            return .green
        case .calculus:
            return .purple
        case .statistics:
            return .orange
        case .trigonometry:
            return .red
        }
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

    // Computed properties
    var percentage: Int {
        return (score * 100) / totalQuestions
    }

    var isPassed: Bool {
        return score == totalQuestions
    }

    var grade: String {
        switch percentage {
        case 90 ... 100:
            return "A"
        case 80 ... 89:
            return "B"
        case 70 ... 79:
            return "C"
        case 60 ... 69:
            return "D"
        default:
            return "F"
        }
    }
}

struct QuizSession {
    var questions: [MathQuestion]
    var currentQuestionIndex: Int = 0
    var selectedAnswers: [Int] = []
    var startTime: Date = .init()
    var score: Int = 0

    // Computed properties
    var currentQuestion: MathQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    var isLastQuestion: Bool {
        return currentQuestionIndex == questions.count - 1
    }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex + 1) / Double(questions.count)
    }
}
