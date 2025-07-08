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

    func getResults(for userId: String, chapter: MathChapter? = nil) -> [QuizResult] {
        var filteredResults = quizResults.filter { $0.userId == userId }

        if let chapter = chapter {
            filteredResults = filteredResults.filter { $0.chapter == chapter }
        }

        return filteredResults.sorted { $0.date > $1.date }
    }

    // Get completed chapters from UserDefaults
    func getCompletedChapters() -> Set<MathChapter> {
        let completedChaptersRaw = UserDefaults.standard.array(forKey: "completedChapters") as? [String] ?? []
        return Set(completedChaptersRaw.compactMap { MathChapter(rawValue: $0) })
    }

    // Save completed chapters to UserDefaults
    func saveCompletedChapters(_ chapters: Set<MathChapter>) {
        let chaptersArray = Array(chapters).map { $0.rawValue }
        UserDefaults.standard.set(chaptersArray, forKey: "completedChapters")
    }

    // Get all currently unlocked chapters
    func getUnlockedChapters() -> Set<MathChapter> {
        let completedChapters = getCompletedChapters()
        var unlockedChapters: Set<MathChapter> = []

        for chapter in MathChapter.allCases {
            if chapter.isUnlocked(completedChapters: completedChapters) {
                unlockedChapters.insert(chapter)
            }
        }

        return unlockedChapters
    }

    func startQuiz(chapter: MathChapter) {
        let filteredQuestions = mathQuestions.filter { $0.chapter == chapter }
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
                let passed = quizPassed
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
            score: quiz.score,
            totalQuestions: quiz.questions.count,
            date: Date(),
            timeSpent: Date().timeIntervalSince(quiz.startTime)
        )

        quizResults.append(result)
        lastQuizResult = result
        selectedAnswer = -1

        // Check if quiz passed (100% required)
        if result.score == result.totalQuestions {
            quizPassed = true

            // Add this chapter to completed chapters
            var completedChapters = getCompletedChapters()
            completedChapters.insert(result.chapter)
            saveCompletedChapters(completedChapters)

            // Notify that chapters may have been unlocked
            NotificationCenter.default.post(name: .chapterUnlocked, object: nil)
        } else {
            quizPassed = false
        }
    }

    func resetQuiz() {
        currentQuiz = nil
        selectedAnswer = -1
        lastQuizResult = nil
    }

    // Get available next chapters (newly unlocked chapters)
    func getAvailableNextChapters() -> [MathChapter] {
        guard let lastResult = lastQuizResult else { return [] }

        let completedChapters = getCompletedChapters()

        // If the last quiz was passed, return the chapters it unlocks that haven't been completed yet
        if lastResult.score == lastResult.totalQuestions {
            return lastResult.chapter.unlocks.filter { !completedChapters.contains($0) }
        }

        return []
    }
}
