import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var mathQuestions: [MathQuestion] = []
    @Published var currentQuiz: QuizSession?
    @Published var selectedAnswer: Int = -1
    @Published var lastQuizResult: QuizResult?
    @Published var quizPassed: Bool = false
    private var quizResults: [QuizResult] = []

    init() {
        loadQuestions()
    }

    func loadQuestions() {
        if let url = Bundle.main.url(forResource: "questions", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                mathQuestions = try decoder.decode([MathQuestion].self, from: data)
            } catch {
                print("Error loading questions: \(error)")
            }
        }
    }

    func addQuestion(_ question: MathQuestion) {
        mathQuestions.append(question)
    }

    func getResults(for userId: String, chapter: MathChapter? = nil, difficulty: Difficulty? = nil) -> [QuizResult] {
        var filteredResults = quizResults.filter { $0.userId == userId }

        if let chapter = chapter {
            filteredResults = filteredResults.filter { $0.chapter == chapter }
        }

        if let difficulty = difficulty {
            filteredResults = filteredResults.filter { $0.difficulty == difficulty }
        }

        return filteredResults.sorted { $0.date > $1.date }
    }

    func startQuiz(chapter: MathChapter, difficulty: Difficulty) {
        let filteredQuestions = mathQuestions.filter { $0.chapter == chapter && $0.difficulty == difficulty }
        currentQuiz = QuizSession(questions: filteredQuestions.shuffled())
        selectedAnswer = -1
        lastQuizResult = nil
        quizPassed = false
    }

    func submitAnswer(_ answer: Int) {
        guard var quiz = currentQuiz else { return }

        selectedAnswer = answer
        quiz.selectedAnswers.append(answer)
        currentQuiz = quiz
    }

    func processAnswer() -> (quizFinished: Bool, quizPassed: Bool) {
        guard var quiz = currentQuiz, let lastAnswer = quiz.selectedAnswers.last else { return (false, false) }

        if lastAnswer == quiz.questions[quiz.currentQuestionIndex].correctAnswer {
            quiz.score += 1
            currentQuiz = quiz
            
            if quiz.currentQuestionIndex < quiz.questions.count - 1 {
                nextQuestion()
                return (quizFinished: false, quizPassed: false)
            } else {
                finishQuiz(userId: "guest")
                let passed = self.quizPassed // Capture state before it's reset
                if passed {
                    startNextChapterQuiz()
                }
                return (quizFinished: true, quizPassed: passed)
            }
        } else {
            finishQuiz(userId: "guest")
            return (quizFinished: true, quizPassed: false)
        }
    }

    func nextQuestion() {
        guard var quiz = currentQuiz else { return }

        if quiz.currentQuestionIndex < quiz.questions.count - 1 {
            quiz.currentQuestionIndex += 1
            currentQuiz = quiz
            selectedAnswer = -1
        }
    }

    func finishQuiz(userId: String) {
        guard let quiz = currentQuiz else { return }

        let result = QuizResult(
            userId: userId,
            chapter: quiz.questions.first?.chapter ?? .algebra,
            difficulty: quiz.questions.first?.difficulty ?? .easy,
            score: quiz.score,
            totalQuestions: quiz.questions.count,
            date: Date(),
            timeSpent: Date().timeIntervalSince(quiz.startTime)
        )

        quizResults.append(result)
        lastQuizResult = result
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
    }

    func resetQuiz() {
        currentQuiz = nil
        selectedAnswer = -1
        lastQuizResult = nil
    }

    func startNextChapterQuiz() {
        guard let lastResult = lastQuizResult else { return }

        let allChapters = MathChapter.allCases
        if let currentIndex = allChapters.firstIndex(of: lastResult.chapter), currentIndex + 1 < allChapters.count {
            let nextChapter = allChapters[currentIndex + 1]
            startQuiz(chapter: nextChapter, difficulty: lastResult.difficulty)
        } else {
            // Handle case where user has finished the last chapter
            // For now, we can just reset the quiz
            resetQuiz()
        }
    }
}
