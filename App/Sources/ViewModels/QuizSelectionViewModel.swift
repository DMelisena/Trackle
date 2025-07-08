import SwiftUI

class QuizSelectionViewModel: ObservableObject {
    private let quizService: QuizService

    @Published var selectedChapter: MathChapter = .numberOperations
    @Published var selectedDifficulty: Difficulty = .easy

    init(quizService: QuizService = .shared) {
        self.quizService = quizService
    }

    var questionCount: Int {
        quizService.mathQuestions.filter { question in
            question.chapter == selectedChapter && question.difficulty == selectedDifficulty
        }.count
    }

    func createQuizViewModel() -> QuizViewModel {
        let questions = quizService.getQuestions(for: selectedChapter, difficulty: selectedDifficulty)
        let quizSession = QuizSession(questions: questions.shuffled())
        return QuizViewModel(quizSession: quizSession, quizService: quizService)
    }
}
