import Foundation

public class QuizService {
    public static let shared = QuizService()
    public private(set) var mathQuestions: [MathQuestion] = []

    private init() {
        loadQuestions()
    }

    private func loadQuestions() {
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

    public func getQuestions(for chapter: MathChapter, difficulty: Difficulty) -> [MathQuestion] {
        mathQuestions.filter { $0.chapter == chapter && $0.difficulty == difficulty }
    }
}
