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

                        let passingScore = Int(Double(lastResult.totalQuestions) * 0.7)

                        Text(lastResult.score >= passingScore ? "Great job!" : "Keep trying! You can do better!")
                            .font(.title2)
                            .foregroundColor(lastResult.score >= passingScore ? .green : .orange)
                    }
                    .padding(.top)

                    // Score Circle

                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                            .frame(width: 150, height: 150)

                        Circle()
                            .trim(from: 0, to: CGFloat(lastResult.percentage) / 100)
                            .stroke(scoreColor(lastResult.percentage), lineWidth: 10)
                            .frame(width: 150, height: 150)
                            .rotationEffect(.degrees(-90))

                        VStack {
                            Text("\(lastResult.percentage)%")
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
                        ResultRow(title: "Questions", value: "\(lastResult.totalQuestions)")
                        ResultRow(title: "Correct", value: "\(lastResult.score)")
                        ResultRow(title: "Time", value: formatTime(lastResult.timeSpent))
                        ResultRow(title: "Status", value: lastResult.score == lastResult.totalQuestions ? "Passed ✅" : "Failed ❌")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)

                    // Show newly unlocked chapters
                    let availableNextChapters = quizViewModel.getAvailableNextChapters()
                    if !availableNextChapters.isEmpty && lastResult.score == lastResult.totalQuestions {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("🎉 New Chapters Unlocked!")
                                .font(.headline)
                                .foregroundColor(.green)

                            ForEach(availableNextChapters, id: \.self) { chapter in
                                Text("• \(chapter.rawValue)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                    }

                    Spacer()

                    // Action Buttons
                    VStack(spacing: 10) {
                        // Show next chapter options if available
                        if !availableNextChapters.isEmpty && lastResult.score == lastResult.totalQuestions {
                            if availableNextChapters.count == 1 {
                                Button("Start \(availableNextChapters.first!.rawValue)") {
                                    quizViewModel.startQuiz(chapter: availableNextChapters.first!)
                                    dismiss()
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            } else {
                                Button("Choose Next Chapter") {
                                    // Close results and let user choose from chapter selection
                                    dismiss()
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }

                        // Retry Button (always show for failed attempts)
                        if lastResult.score != lastResult.totalQuestions {
                            Button("Try Again") {
                                quizViewModel.startQuiz(chapter: lastResult.chapter)
                                dismiss()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }

                        // Back to Home Button
                        Button("Back to Home") {
                            quizViewModel.resetQuiz()
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                } else {
                    // Fallback if no result available
                    VStack {
                        Text("No results available")
                            .font(.title)
                            .foregroundColor(.secondary)

                        Button("Back to Home") {
                            dismiss()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }

    // Helper function to determine score color
    private func scoreColor(_ percentage: Int) -> Color {
        switch percentage {
        case 90 ... 100:
            return .green
        case 70 ... 89:
            return .yellow
        case 50 ... 69:
            return .orange
        default:
            return .red
        }
    }

    // Helper function to format time
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
