import Combine
import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var mathQuestions: [MathQuestion] = []
    @Published var currentQuiz: QuizSession?
    @Published var selectedAnswer: Int = -1
    @Published var lastQuizResult: QuizResult?
    @Published var quizPassed: Bool = false
    @Published var isLoading: Bool = false

    private var quizResults: [QuizResult] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadQuestions()
        loadQuizResults()
    }

    // MARK: - Data Loading

    func loadQuestions() {
        isLoading = true

        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            print("Error: questions.json not found")
            isLoading = false
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            mathQuestions = try decoder.decode([MathQuestion].self, from: data)
            print("Successfully loaded \(mathQuestions.count) questions")
        } catch {
            print("Error loading questions: \(error)")
            mathQuestions = []
        }

        isLoading = false
    }

    private func loadQuizResults() {
        if let data = UserDefaults.standard.data(forKey: "quizResults"),
           let results = try? JSONDecoder().decode([QuizResult].self, from: data)
        {
            quizResults = results
        }
    }

    private func saveQuizResults() {
        if let data = try? JSONEncoder().encode(quizResults) {
            UserDefaults.standard.set(data, forKey: "quizResults")
        }
    }

    // MARK: - Chapter Management

    func getCompletedChapters() -> Set<MathChapter> {
        let completedChaptersRaw = UserDefaults.standard.array(forKey: "completedChapters") as? [String] ?? []
        return Set(completedChaptersRaw.compactMap { MathChapter(rawValue: $0) })
    }

    func saveCompletedChapters(_ chapters: Set<MathChapter>) {
        let chaptersArray = Array(chapters).map { $0.rawValue }
        UserDefaults.standard.set(chaptersArray, forKey: "completedChapters")
    }

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

    func getAvailableNextChapters() -> [MathChapter] {
        guard let lastResult = lastQuizResult else { return [] }

        let completedChapters = getCompletedChapters()

        // If the last quiz was passed, return the chapters it unlocks that haven't been completed yet
        if lastResult.isPassed {
            return lastResult.chapter.unlocks.filter { !completedChapters.contains($0) }
        }

        return []
    }

    // MARK: - Quiz Session Management

    func startQuiz(chapter: MathChapter) {
        let filteredQuestions = mathQuestions.filter { $0.chapter == chapter }

        guard !filteredQuestions.isEmpty else {
            print("No questions available for chapter: \(chapter.rawValue)")
            return
        }

        currentQuiz = QuizSession(questions: filteredQuestions.shuffled())
        selectedAnswer = -1
        lastQuizResult = nil
        quizPassed = false

        print("Started quiz for \(chapter.rawValue) with \(filteredQuestions.count) questions")
    }

    func submitAnswer(_ answer: Int) {
        guard var quiz = currentQuiz else { return }

        selectedAnswer = answer
        quiz.selectedAnswers.append(answer)
        currentQuiz = quiz

        print("Answer submitted: \(answer)")
    }

    func processAnswer() -> (quizFinished: Bool, quizPassed: Bool) {
        guard var quiz = currentQuiz,
              let lastAnswer = quiz.selectedAnswers.last,
              let currentQuestion = quiz.currentQuestion
        else {
            return (false, false)
        }

        // Check if answer is correct
        if lastAnswer == currentQuestion.correctAnswer {
            quiz.score += 1
            currentQuiz = quiz
            print("Correct answer! Score: \(quiz.score)")

            // Check if this was the last question
            if quiz.isLastQuestion {
                finishQuiz(userId: "guest")
                return (quizFinished: true, quizPassed: quizPassed)
            } else {
                nextQuestion()
                return (quizFinished: false, quizPassed: false)
            }
        } else {
            // Wrong answer - end quiz immediately
            print("Wrong answer. Quiz ended.")
            finishQuiz(userId: "guest")
            return (quizFinished: true, quizPassed: false)
        }
    }

    func nextQuestion() {
        guard var quiz = currentQuiz else { return }

        if !quiz.isLastQuestion {
            quiz.currentQuestionIndex += 1
            currentQuiz = quiz
            selectedAnswer = -1
            print("Next question: \(quiz.currentQuestionIndex + 1)")
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
        saveQuizResults()

        // Check if quiz passed (100% required)
        quizPassed = result.isPassed

        if result.isPassed {
            // Add this chapter to completed chapters
            var completedChapters = getCompletedChapters()
            completedChapters.insert(result.chapter)
            saveCompletedChapters(completedChapters)

            // Notify that chapters may have been unlocked
            NotificationCenter.default.post(name: .chapterUnlocked, object: nil)

            print("Quiz passed! Chapter \(result.chapter.rawValue) completed.")
        } else {
            print("Quiz failed. Score: \(result.score)/\(result.totalQuestions)")
        }
    }

    func resetQuiz() {
        currentQuiz = nil
        selectedAnswer = -1
        lastQuizResult = nil
        quizPassed = false
    }

    // MARK: - Statistics

    func getResults(for userId: String, chapter: MathChapter? = nil) -> [QuizResult] {
        var filteredResults = quizResults.filter { $0.userId == userId }

        if let chapter = chapter {
            filteredResults = filteredResults.filter { $0.chapter == chapter }
        }

        return filteredResults.sorted { $0.date > $1.date }
    }

    func getBestScore(for chapter: MathChapter) -> QuizResult? {
        return quizResults
            .filter { $0.chapter == chapter }
            .max { $0.score < $1.score }
    }

    func getAverageScore(for chapter: MathChapter) -> Double? {
        let results = quizResults.filter { $0.chapter == chapter }
        guard !results.isEmpty else { return nil }

        let totalScore = results.reduce(0) { $0 + $1.score }
        return Double(totalScore) / Double(results.count)
    }

    func getTotalQuestionsAnswered() -> Int {
        return quizResults.reduce(0) { $0 + $1.totalQuestions }
    }

    func getTotalCorrectAnswers() -> Int {
        return quizResults.reduce(0) { $0 + $1.score }
    }

    // MARK: - Utility Functions

    func addQuestion(_ question: MathQuestion) {
        mathQuestions.append(question)
    }

    func getQuestionsCount(for chapter: MathChapter) -> Int {
        return mathQuestions.filter { $0.chapter == chapter }.count
    }

    func getQuestionsCount(for chapter: MathChapter, difficulty: QuestionDifficulty) -> Int {
        return mathQuestions.filter { $0.chapter == chapter && $0.difficulty == difficulty }.count
    }
}
