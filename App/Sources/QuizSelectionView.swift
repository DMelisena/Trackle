import SwiftUI

struct QuizSelectionView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @State private var selectedChapter: MathChapter = .algebra
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var showingQuiz = false

    var body: some View {
        VStack(spacing: 20) {
            // App Title
            VStack {
                Image(systemName: "function")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding()

                Text("Math Quiz")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Test Your Mathematical Knowledge")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }

            Text("Select Quiz Parameters")
                .font(.title2)
                .fontWeight(.semibold)

            VStack(spacing: 15) {
                // Difficulty Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Difficulty")
                        .font(.headline)

                    Picker("Difficulty", selection: $selectedDifficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            HStack {
                                Text(difficulty.rawValue)
                                Spacer()
                                Image(systemName: difficultyIcon(difficulty))
                                    .foregroundColor(difficultyColor(difficulty))
                            }
                            .tag(difficulty)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)

            // Question Count Preview
            let questionCount = quizViewModel.mathQuestions.filter { $0.difficulty == selectedDifficulty }.count

            Text("Available Questions: \(questionCount)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            // Start Quiz Button
            Button("Start Quiz") {
                // Start with the first chapter by default, difficulty from selection
                quizViewModel.startQuiz(chapter: MathChapter.allCases.first ?? .algebra, difficulty: selectedDifficulty)
                showingQuiz = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(questionCount > 0 ? Color.blue : Color.gray)
            .foregroundColor(.primary)
            .cornerRadius(10)
            .disabled(questionCount == 0)

            if questionCount == 0 {
                Text("No questions available for this combination")
                    .font(.caption)
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("")
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingQuiz) {
            QuizView()
                .environmentObject(quizViewModel)
        }
    }

    private func difficultyIcon(_ difficulty: Difficulty) -> String {
        switch difficulty {
        case .easy: return "circle"
        case .medium: return "circle.fill"
        case .hard: return "flame"
        }
    }

    private func difficultyColor(_ difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}
