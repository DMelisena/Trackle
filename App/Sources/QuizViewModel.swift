import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var mathQuestions: [MathQuestion] = [
        MathQuestion(chapter: .algebra, difficulty: .easy, imageName: "algebra_basic",
                     question: "What is $2x + 3 = 11$?",
                     options: ["x = 3", "x = 4", "x = 5", "x = 6"],
                     correctAnswer: 1),
        
        MathQuestion(chapter: .algebra, difficulty: .medium, imageName: "algebra_medium",
                     question: "Solve: $3x^2 - 12x + 9 = 0$",
                     options: ["x = 1, 3", "x = 2, 4", "x = 3, 1", "x = 0, 4"],
                     correctAnswer: 0),
        
        MathQuestion(chapter: .geometry, difficulty: .easy, imageName: "geometry_basic",
                     question: "What is the area of a rectangle with length 5 and width 3?",
                     options: ["12", "15", "18", "20"],
                     correctAnswer: 1),
        
        MathQuestion(chapter: .geometry, difficulty: .hard, imageName: "geometry_hard",
                     question: "What is the volume of a sphere with radius 3?",
                     options: ["$36\\pi$", "$27\\pi$", "$54\\pi$", "$81\\pi$"],
                     correctAnswer: 0),
        
        MathQuestion(chapter: .calculus, difficulty: .medium, imageName: "calculus_medium",
                     question: "What is the derivative of $x^2$?",
                     options: ["x", "2x", "$x^2$", "$2x^2$"],
                     correctAnswer: 1),
        
        MathQuestion(chapter: .calculus, difficulty: .hard, imageName: "calculus_hard",
                     question: "What is $\\int x^2 dx$?",
                     options: ["$x^3/3 + C$", "$x^3 + C$", "$2x + C$", "$x^2/2 + C$"],
                     correctAnswer: 0),
        
        MathQuestion(chapter: .statistics, difficulty: .easy, imageName: "stats_basic",
                     question: "What is the mean of [2, 4, 6, 8]?",
                     options: ["4", "5", "6", "7"],
                     correctAnswer: 1),
        
        MathQuestion(chapter: .trigonometry, difficulty: .medium, imageName: "trig_medium",
                     question: "What is $\\sin(90°)$?",
                     options: ["0", "1", "$\\sqrt{2}/2$", "$\\sqrt{3}/2$"],
                     correctAnswer: 1),

        // New Algebra Questions
        MathQuestion(chapter: .algebra, difficulty: .easy, imageName: "algebra_easy_2",
                     question: "If $x + 7 = 15$, what is $x$?",
                     options: ["6", "7", "8", "9"],
                     correctAnswer: 2),
        MathQuestion(chapter: .algebra, difficulty: .medium, imageName: "algebra_medium_2",
                     question: "Factorize: $x^2 - 9$",
                     options: ["$(x-3)(x-3)$", "$(x+3)(x+3)$", "$(x-3)(x+3)$", "$(x-9)(x+1)$"],
                     correctAnswer: 2),
        MathQuestion(chapter: .algebra, difficulty: .hard, imageName: "algebra_hard_1",
                     question: "Solve for $x$: $2^{2x-1} = 8$",
                     options: ["1", "2", "3", "4"],
                     correctAnswer: 1),
        MathQuestion(chapter: .algebra, difficulty: .hard, imageName: "algebra_hard_2",
                     question: "If $f(x) = x^2 + 2x - 1$ and $g(x) = x - 3$, find $f(g(x))$",
                     options: ["$x^2 - 4x + 2$", "$x^2 - 4x + 8$", "$x^2 - 2x + 2$", "$x^2 + 2x - 4$"],
                     correctAnswer: 0),

        // New Geometry Questions
        MathQuestion(chapter: .geometry, difficulty: .easy, imageName: "geometry_easy_2",
                     question: "What is the perimeter of a square with side length 4?",
                     options: ["8", "12", "16", "20"],
                     correctAnswer: 2),
        MathQuestion(chapter: .geometry, difficulty: .medium, imageName: "geometry_medium_1",
                     question: "A triangle has angles $30°$ and $90°$. What is the third angle?",
                     options: ["45°", "60°", "75°", "90°"],
                     correctAnswer: 1),
        MathQuestion(chapter: .geometry, difficulty: .medium, imageName: "geometry_medium_2",
                     question: "What is the circumference of a circle with radius 7? (Use $\\pi \\approx 22/7$)",
                     options: ["22", "44", "88", "154"],
                     correctAnswer: 1),
        MathQuestion(chapter: .geometry, difficulty: .hard, imageName: "geometry_hard_2",
                     question: "If a cube has a surface area of $150 \\text{ cm}^2$, what is the length of one of its sides?",
                     options: ["3 cm", "4 cm", "5 cm", "6 cm"],
                     correctAnswer: 2),

        // New Calculus Questions
        MathQuestion(chapter: .calculus, difficulty: .easy, imageName: "calculus_easy_1",
                     question: "What is the derivative of $5x$?",
                     options: ["$x$", "$5$", "$5x$", "$0$"],
                     correctAnswer: 1),
        MathQuestion(chapter: .calculus, difficulty: .easy, imageName: "calculus_easy_2",
                     question: "What is $\\frac{d}{dx}(C)$ where C is a constant?",
                     options: ["$x$", "$C$", "$0$", "$1$"],
                     correctAnswer: 2),
        MathQuestion(chapter: .calculus, difficulty: .medium, imageName: "calculus_medium_2",
                     question: "Evaluate $\\lim_{x \\to 2} (x^2 + 3)$",
                     options: ["5", "7", "9", "11"],
                     correctAnswer: 2),
        MathQuestion(chapter: .calculus, difficulty: .hard, imageName: "calculus_hard_2",
                     question: "What is $\\int_0^1 (2x + 1) dx$?",
                     options: ["1", "2", "3", "4"],
                     correctAnswer: 1),

        // New Statistics Questions
        MathQuestion(chapter: .statistics, difficulty: .easy, imageName: "stats_easy_2",
                     question: "What is the mode of the data set [1, 2, 2, 3, 4]?",
                     options: ["1", "2", "3", "4"],
                     correctAnswer: 1),
        MathQuestion(chapter: .statistics, difficulty: .medium, imageName: "stats_medium_1",
                     question: "What is the median of the data set [10, 5, 20, 15, 25]?",
                     options: ["10", "15", "20", "25"],
                     correctAnswer: 1),
        MathQuestion(chapter: .statistics, difficulty: .medium, imageName: "stats_medium_2",
                     question: "What is the range of the data set [1, 5, 2, 8, 3]?",
                     options: ["5", "6", "7", "8"],
                     correctAnswer: 2),
        MathQuestion(chapter: .statistics, difficulty: .hard, imageName: "stats_hard_1",
                     question: "In a normal distribution, approximately what percentage of data falls within one standard deviation of the mean?",
                     options: ["50%", "68%", "95%", "99.7%"],
                     correctAnswer: 1),

        // New Trigonometry Questions
        MathQuestion(chapter: .trigonometry, difficulty: .easy, imageName: "trig_easy_1",
                     question: "In a right triangle, which side is opposite the right angle?",
                     options: ["Adjacent", "Opposite", "Hypotenuse", "Leg"],
                     correctAnswer: 2),
        MathQuestion(chapter: .trigonometry, difficulty: .easy, imageName: "trig_easy_2",
                     question: "What is $\\cos(0°)$?",
                     options: ["0", "1", "-1", "Undefined"],
                     correctAnswer: 1),
        MathQuestion(chapter: .trigonometry, difficulty: .medium, imageName: "trig_medium_2",
                     question: "If $\\tan(\\theta) = 1$, what is $\\theta$ in degrees (for $0° \\le \\theta < 90°$)?",
                     options: ["30°", "45°", "60°", "90°"],
                     correctAnswer: 1),
        MathQuestion(chapter: .trigonometry, difficulty: .hard, imageName: "trig_hard_1",
                     question: "Simplify: $\\sin^2(x) + \\cos^2(x)$",
                     options: ["$\\sin(2x)$", "$1$", "$\\cos(2x)$", "$0$"],
                     correctAnswer: 1),
        MathQuestion(chapter: .trigonometry, difficulty: .hard, imageName: "trig_hard_2",
                     question: "What is the value of $\\sin(180°)$?",
                     options: ["-1", "0", "1", "Undefined"],
                     correctAnswer: 1)
    ]
    @Published var currentQuiz: QuizSession?
    @Published var quizResults: [QuizResult] = []
    @Published var selectedAnswer: Int = -1

    func startQuiz(chapter: MathChapter, difficulty: Difficulty) {
        let filteredQuestions = mathQuestions.filter { $0.chapter == chapter && $0.difficulty == difficulty }
        currentQuiz = QuizSession(questions: filteredQuestions.shuffled())
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
        currentQuiz = nil
        selectedAnswer = -1
    }

    func addQuestion(_ question: MathQuestion) {
        mathQuestions.append(question)
    }

    func deleteQuestion(at index: Int) {
        mathQuestions.remove(at: index)
    }

    func getResults(for userId: String, chapter: MathChapter? = nil, difficulty: Difficulty? = nil) -> [QuizResult] {
        var filtered = quizResults.filter { $0.userId == userId }

        if let chapter = chapter {
            filtered = filtered.filter { $0.chapter == chapter }
        }

        if let difficulty = difficulty {
            filtered = filtered.filter { $0.difficulty == difficulty }
        }

        return filtered.sorted { $0.date > $1.date }
    }
}
