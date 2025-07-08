import Foundation

public enum MathChapter: String, CaseIterable, Codable {
    case numberOperations = "Number Operations"
    case exponents = "Exponents"
    case logarithms = "Logarithms"
    case sequencesAndSeries = "Sequences & Series"
    case algebra = "Algebra"
    case linearEquations = "Linear Equations"
    case quadraticFunctions = "Quadratic Functions"
    case geometry = "Geometry"
    case trigonometry = "Trigonometry"
    case calculus = "Calculus"
}

public enum Difficulty: String, CaseIterable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}
