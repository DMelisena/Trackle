import SwiftUI

class QuizResultViewModel: ObservableObject {
    @Published var result: QuizResult
    private let quizService: QuizService

    init(result: QuizResult, quizService: QuizService = .shared) {
        self.result = result
        self.quizService = quizService
    }

    var percentage: Int {
        (result.score * 100) / result.totalQuestions
    }

    var passingScore: Int {
        Int(Double(result.totalQuestions) * 0.7)
    }

    var isPassed: Bool {
        result.score >= passingScore
    }

    func createNextChapterQuizViewModel() -> QuizViewModel? {
        let allChapters = MathChapter.allCases
        if let currentIndex = allChapters.firstIndex(of: result.chapter), currentIndex + 1 < allChapters.count {
            let nextChapter = allChapters[currentIndex + 1]
            let questions = quizService.getQuestions(for: nextChapter, difficulty: result.difficulty)
            let quizSession = QuizSession(questions: questions.shuffled())
            return QuizViewModel(quizSession: quizSession, quizService: quizService)
        }
        return nil
    }
    
    func createRetakeQuizViewModel() -> QuizViewModel {
        let questions = quizService.getQuestions(for: result.chapter, difficulty: result.difficulty)
        let quizSession = QuizSession(questions: questions.shuffled())
        return QuizViewModel(quizSession: quizSession, quizService: quizService)
    }
}
