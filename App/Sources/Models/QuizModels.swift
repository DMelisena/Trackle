import Foundation

public struct MathQuestion: Identifiable, Codable {
    public let id = UUID()
    public var chapter: MathChapter
    public var difficulty: Difficulty
    public var imageName: String
    public var question: String
    public var options: [String]
    public var correctAnswer: Int

    public init(id: UUID = UUID(), chapter: MathChapter, difficulty: Difficulty, imageName: String, question: String, options: [String], correctAnswer: Int) {
        self.chapter = chapter
        self.difficulty = difficulty
        self.imageName = imageName
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
    }
}

public struct QuizSession {
    public var questions: [MathQuestion]
    public var currentQuestionIndex: Int = 0
    public var selectedAnswers: [Int] = []
    public var startTime: Date = .init()
    public var score: Int = 0

    public init(questions: [MathQuestion], currentQuestionIndex: Int = 0, selectedAnswers: [Int] = [], startTime: Date = .init(), score: Int = 0) {
        self.questions = questions
        self.currentQuestionIndex = currentQuestionIndex
        self.selectedAnswers = selectedAnswers
        self.startTime = startTime
        self.score = score
    }
}

public struct QuizResult: Identifiable, Codable {
    public let id = UUID()
    public var userId: String
    public var chapter: MathChapter
    public var difficulty: Difficulty
    public var score: Int
    public var totalQuestions: Int
    public var date: Date
    public var timeSpent: TimeInterval

    public init(id: UUID = UUID(), userId: String, chapter: MathChapter, difficulty: Difficulty, score: Int, totalQuestions: Int, date: Date, timeSpent: TimeInterval) {
        self.userId = userId
        self.chapter = chapter
        self.difficulty = difficulty
        self.score = score
        self.totalQuestions = totalQuestions
        self.date = date
        self.timeSpent = timeSpent
    }
}
