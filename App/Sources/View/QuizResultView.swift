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
                        let isPassed = lastResult.score == lastResult.totalQuestions

                        Text(isPassed ? "Perfect! New chapters unlocked!" : "Keep trying! You can do better!")
                            .font(.title2)
                            .foregroundColor(isPassed ? .green : .orange)
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
                                Button("Choose Next Chapter
