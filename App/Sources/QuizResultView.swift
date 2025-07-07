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

                        let percentage = (lastResult.score * 100) / lastResult.totalQuestions
                        let passingScore = Int(Double(lastResult.totalQuestions) * 0.7)

                        Text(lastResult.score >= passingScore ? "Great job! Chapter unlocked!" : "Keep trying! You can do better!")
                            .font(.title2)
                            .foregroundColor(lastResult.score >= passingScore ? .green : .orange)
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

                        let passingScore = Int(Double(lastResult.totalQuestions) * 0.7)
                        ResultRow(title: "Status", value: lastResult.score >= passingScore ? "Passed ✅" : "Failed ❌")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)

                    Spacer()

                    // Action Buttons
                    VStack(spacing: 10) {
                        let passingScore = Int(Double(lastResult.totalQuestions) * 0.7)
                        let unlockedChapterIndex = UserDefaults.standard.integer(forKey: "unlockedChapterIndex")

                        // Show next chapter button only if current chapter is passed and next chapter is unlocked
                        if lastResult.score >= passingScore,
                           let currentIndex = MathChapter.allCases.firstIndex(of: lastResult.chapter),
                           currentIndex + 1 < MathChapter.allCases.count,
                           currentIndex + 1 <= unlockedChapterIndex
                        {
                            Button("Next Chapter") {
                                quizViewModel.startNextChapterQuiz()
                                dismiss()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }

                        Button("Retake Quiz") {
                            quizViewModel.startQuiz(chapter: lastResult.chapter, difficulty: lastResult.difficulty)
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("Back to Home") {
                            quizViewModel.resetQuiz()
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

                    Button("Back to Home") {
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
        case 70 ... 100: return .green
        case 50 ... 69: return .orange
        default: return .red
        }
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
