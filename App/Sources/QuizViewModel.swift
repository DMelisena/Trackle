import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var mathQuestions: [MathQuestion] = [
        MathQuestion(chapter: .algebra, difficulty: .easy, imageName: "algebra_basic",
                     question: "What is 2x + 3 = 11?",
                     options: ["x = 3", "x = 4", "x = 5", "x = 6"],
                     correctAnswer: 1),

        MathQuestion(chapter: .algebra, difficulty: .medium, imageName: "algebra_medium",
                     question: "Solve: 3x² - 12x + 9 = 0",
                     options: ["x = 1, 3", "x = 2, 4", "x = 3, 1", "x = 0, 4"],
                     correctAnswer: 0),

        MathQuestion(chapter: .geometry, difficulty: .easy, imageName: "geometry_basic",
                     question: "What is the area of a rectangle with length 5 and width 3?",
                     options: ["12", "15", "18", "20"],
                     correctAnswer: 1),

        MathQuestion(chapter: .geometry, difficulty: .hard, imageName: "geometry_hard",
                     question: "What is the volume of a sphere with radius 3?",
                     options: ["36π", "27π", "54π", "81π"],
                     correctAnswer: 0),

        MathQuestion(chapter: .calculus, difficulty: .medium, imageName: "calculus_medium",
                     question: "What is the derivative of x²?",
                     options: ["x", "2x", "x²", "2x²"],
                     correctAnswer: 1),

        MathQuestion(chapter: .calculus, difficulty: .hard, imageName: "calculus_hard",
                     question: "What is ∫ x² dx?",
                     options: ["x³/3 + C", "x³ + C", "2x + C", "x²/2 + C"],
                     correctAnswer: 0),

        MathQuestion(chapter: .statistics, difficulty: .easy, imageName: "stats_basic",
                     question: "What is the mean of [2, 4, 6, 8]?",
                     options: ["4", "5", "6", "7"],
                     correctAnswer: 1),

        MathQuestion(chapter: .trigonometry, difficulty: .medium, imageName: "trig_medium",
                     question: "What is sin(90°)?",
                     options: ["0", "1", "√2/2", "√3/2"],
                     correctAnswer: 1),

        // Additional questions for variety
        MathQuestion(chapter: .algebra, difficulty: .easy, imageName: "algebra_easy_2",
                     question: "If x + 7 = 15, what is x?",
                     options: ["6", "7", "8", "9"],
                     correctAnswer: 2),

        MathQuestion(chapter: .algebra, difficulty: .medium, imageName: "algebra_medium_2",
                     question: "Factorize: x² - 9",
                     options: ["(x-3)(x-3)", "(x+3)(x+3)", "(x-3)(x+3)", "(x-9)(x+1)"],
                     correctAnswer: 2),

        MathQuestion(chapter: .algebra, difficulty: .hard, imageName: "algebra_hard_1",
                     question: "Solve for x: 2^(2x-1) = 8",
                     options: ["1", "2", "3", "4"],
                     correctAnswer: 1),

        MathQuestion(chapter: .geometry, difficulty: .easy, imageName: "geometry_easy_2",
                     question: "What is the perimeter of a square with side length 4?",
                     options: ["8", "12", "16", "20"],
                     correctAnswer: 2),

        MathQuestion(chapter: .geometry, difficulty: .medium, imageName: "geometry_medium_1",
                     question: "A triangle has angles 30° and 90°. What is the third angle?",
                     options: ["45°", "60°", "75°", "90°"],
                     correctAnswer: 1),

        MathQuestion(chapter: .calculus, difficulty: .easy, imageName: "calculus_easy_1",
                     question: "What is the derivative of 5x?",
                     options: ["x", "5", "5x", "0"],
                     correctAnswer: 1),

        MathQuestion(chapter: .calculus, difficulty: .easy, imageName: "calculus_easy_2",
                     question: "What is d/dx(C) where C is a constant?",
                     options: ["x", "C", "0", "1"],
                     correctAnswer: 2),

        MathQuestion(chapter: .statistics, difficulty: .easy, imageName: "stats_easy_2",
                     question: "What is the mode of the data set [1, 2, 2, 3, 4]?",
                     options: ["1", "2", "3", "4"],
                     correctAnswer: 1),

        MathQuestion(chapter: .statistics, difficulty: .medium, imageName: "stats_medium_1",
                     question: "What is the median of the data set [10, 5, 20, 15, 25]?",
                     options: ["10", "15", "20", "25"],
                     correctAnswer: 1),

        MathQuestion(chapter: .trigonometry, difficulty: .easy, imageName: "trig_easy_1",
                     question: "In a right triangle, which side is opposite the right angle?",
                     options: ["Adjacent", "Opposite", "Hypotenuse", "Leg"],
                     correctAnswer: 2),

        MathQuestion(chapter: .trigonometry, difficulty: .easy, imageName: "trig_easy_2",
                     question: "What is cos(0°)?",
                     options: ["0", "1", "-1", "Undefined"],
                     correctAnswer: 1),

        MathQuestion(chapter: .trigonometry, difficulty: .medium, imageName: "trig_medium_2",
                     question: "If tan(θ) = 1, what is θ in degrees (for 0° ≤ θ < 90°)?",
                     options: ["30°", "45°", "60°", "90°"],
                     correctAnswer: 1),
    ]

    @Published var currentQuiz: QuizSession?
    @Published var selectedAnswer: Int = -1
    @Published var lastQuizResult: QuizResult?
    private var quizResults: [QuizResult] = []

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
    }

    func submitAnswer(_ answer: Int) {
        guard var quiz = currentQuiz else { return }

        selectedAnswer = answer

        if answer == quiz.questions[quiz.currentQuestionIndex].correctAnswer {
            quiz.score += 1
        }

        quiz.selectedAnswers.append(answer)
        currentQuiz = quiz
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

        let allChapters = MathChapter.allCases
        if let currentIndex = allChapters.firstIndex(of: result.chapter) {
            let currentUnlockedIndex = UserDefaults.standard.integer(forKey: "unlockedChapterIndex")
            if currentIndex >= currentUnlockedIndex {
                UserDefaults.standard.set(currentIndex + 1, forKey: "unlockedChapterIndex")
            }
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
        }
    }
}
