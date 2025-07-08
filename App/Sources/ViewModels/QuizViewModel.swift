import SwiftUI

class QuizViewModel: ObservableObject, Identifiable {
    let id = UUID()
    @Published var currentQuiz: QuizSession
    @Published var selectedAnswer: Int = -1
    @Published var quizPassed: Bool = false
    
    private let quizService: QuizService
    private var quizResults: [QuizResult] = []

    init(quizSession: QuizSession, quizService: QuizService = .shared) {
        self.currentQuiz = quizSession
        self.quizService = quizService
    }

    func submitAnswer(_ answer: Int) {
        selectedAnswer = answer
        currentQuiz.selectedAnswers.append(answer)
    }

    func processAnswer() -> (quizFinished: Bool, quizPassed: Bool) {
        guard let lastAnswer = currentQuiz.selectedAnswers.last else { return (false, false) }

        if lastAnswer == currentQuiz.questions[currentQuiz.currentQuestionIndex].correctAnswer {
            currentQuiz.score += 1
            
            if currentQuiz.currentQuestionIndex < currentQuiz.questions.count - 1 {
                nextQuestion()
                return (quizFinished: false, quizPassed: false)
            } else {
                let result = finishQuiz(userId: "guest")
                self.quizPassed = result.score == result.totalQuestions
                if self.quizPassed {
                    startNextChapterQuiz()
                }
                return (quizFinished: true, quizPassed: self.quizPassed)
            }
        } else {
            _ = finishQuiz(userId: "guest")
            return (quizFinished: true, quizPassed: false)
        }
    }

    func nextQuestion() {
        if currentQuiz.currentQuestionIndex < currentQuiz.questions.count - 1 {
            currentQuiz.currentQuestionIndex += 1
            selectedAnswer = -1
        }
    }

    func finishQuiz(userId: String) -> QuizResult {
        let result = QuizResult(
            userId: userId,
            chapter: currentQuiz.questions.first?.chapter ?? .numberOperations,
            difficulty: currentQuiz.questions.first?.difficulty ?? .easy,
            score: currentQuiz.score,
            totalQuestions: currentQuiz.questions.count,
            date: Date(),
            timeSpent: Date().timeIntervalSince(currentQuiz.startTime)
        )

        quizResults.append(result)
        selectedAnswer = -1

        if result.score == result.totalQuestions {
            quizPassed = true
            let allChapters = MathChapter.allCases
            if let currentIndex = allChapters.firstIndex(of: result.chapter) {
                let currentUnlockedIndex = UserDefaults.standard.integer(forKey: "unlockedChapterIndex")
                if currentIndex >= currentUnlockedIndex {
                    UserDefaults.standard.set(currentIndex + 1, forKey: "unlockedChapterIndex")
                }
            }
        } else {
            quizPassed = false
        }
        return result
    }

    func resetQuiz() {
        // This should be handled by creating a new QuizViewModel
    }

    func startNextChapterQuiz() {
        let lastChapter = currentQuiz.questions.first?.chapter ?? .numberOperations
        let lastDifficulty = currentQuiz.questions.first?.difficulty ?? .easy
        
        let allChapters = MathChapter.allCases
        if let currentIndex = allChapters.firstIndex(of: lastChapter), currentIndex + 1 < allChapters.count {
            let nextChapter = allChapters[currentIndex + 1]
            let questions = quizService.getQuestions(for: nextChapter, difficulty: lastDifficulty)
            self.currentQuiz = QuizSession(questions: questions.shuffled())
            self.selectedAnswer = -1
            self.quizPassed = false
        } else {
            // Handle case where user has finished the last chapter
            // For now, we can just reset the quiz
            resetQuiz()
        }
    }
    
    func createResultViewModel() -> QuizResultViewModel {
        let result = finishQuiz(userId: "guest")
        return QuizResultViewModel(result: result, quizService: quizService)
    }
}
