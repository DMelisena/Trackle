import Foundation

public struct Quiz {
    let questions: [Question]
    var currentQuestionIndex: Int
    var score: Int
    let chapter: MathChapter
}

public struct Question: Codable, Identifiable {
    public var id: String
    let chapter: MathChapter
    let question: String
    let options: [String]
    let correctAnswer: String
    let imageName: String?
}