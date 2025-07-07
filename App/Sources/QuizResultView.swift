import SwiftUI

struct QuizResultView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let lastResult = quizViewModel.lastQuizResult {
                    // Results Header
                    VStack(spacing: 10) {
                        Text("Quiz Complete!")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Great job!")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)

                    // Score Circle
                    let percentage = (lastResult.score * 100) / lastResult.totalQuestions

                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                            .frame(width: 150, height: 150)

                        Circle()
                            .trim(from: 0, to: CGFloat(percentage) / 100)
                            .stroke(scoreColor(percentage), lineWidth: 10)
                            .frame(width: 150, height: 150)
                            .rotationEffect(.degrees(-90))

                        VStack {
                            Text("\(percentage)%")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("\(lastResult.score)/\(lastResult.totalQuestions)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    // Result Details
                    VStack(spacing: 15) {
                        ResultRow(title: "Chapter", value: lastResult.chapter.rawValue)
                        ResultRow(title: "Difficulty", value: lastResult.difficulty.rawValue)
                        ResultRow(title: "Questions", value: "\(lastResult.totalQuestions)")
                        ResultRow(title: "Correct", value: "\(lastResult.score)")
                        ResultRow(title: "Time", value: formatTime(lastResult.timeSpent))
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)

                    Spacer()

                    // Action Buttons
                    VStack(spacing: 10) {
                        Button("Take Another Quiz") {
                            quizViewModel.resetQuiz()
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("Exit") {
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                    }
                } else {
                    Text("No quiz results available")
                        .font(.title)
                        .foregroundColor(.secondary)

                    Spacer()

                    Button("Back to Quiz Selection") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func scoreColor(_ percentage: Int) -> Color {
        switch percentage {
        case 80 ... 100: return .green
        case 60 ... 79: return .orange
        default: return .red
        }
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
