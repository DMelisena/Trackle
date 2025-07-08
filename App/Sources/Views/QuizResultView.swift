import SwiftUI

struct QuizResultView: View {
    @StateObject var viewModel: QuizResultViewModel
    @Environment(\.dismiss) var dismiss
    @State private var nextQuiz: QuizViewModel?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Results Header
                VStack(spacing: 10) {
                    Text("Quiz Complete!")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(viewModel.isPassed ? "Great job! Chapter unlocked!" : "Keep trying! You can do better!")
                        .font(.title2)
                        .foregroundColor(viewModel.isPassed ? .green : .orange)
                }
                .padding(.top)

                // Score Circle
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                        .frame(width: 150, height: 150)

                    Circle()
                        .trim(from: 0, to: CGFloat(viewModel.percentage) / 100)
                        .stroke(scoreColor(viewModel.percentage), lineWidth: 10)
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-90))

                    VStack {
                        Text("\(viewModel.percentage)%")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("\(viewModel.result.score)/\(viewModel.result.totalQuestions)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                // Result Details
                VStack(spacing: 15) {
                    ResultRow(title: "Chapter", value: viewModel.result.chapter.rawValue)
                    
                    ResultRow(title: "Questions", value: "\(viewModel.result.totalQuestions)")
                    ResultRow(title: "Correct", value: "\(viewModel.result.score)")
                    ResultRow(title: "Time", value: formatTime(viewModel.result.timeSpent))
                    ResultRow(title: "Status", value: viewModel.isPassed ? "Passed ✅" : "Failed ❌")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)

                Spacer()

                // Action Buttons
                VStack(spacing: 10) {
                    if viewModel.isPassed {
                        Button("Next Chapter") {
                            if let nextQuizViewModel = viewModel.createNextChapterQuizViewModel() {
                                self.nextQuiz = nextQuizViewModel
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                    Button("Retake Quiz") {
                        self.nextQuiz = viewModel.createRetakeQuizViewModel()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Back to Home") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
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
            .fullScreenCover(item: $nextQuiz) { quizViewModel in
                QuizView(viewModel: quizViewModel)
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


