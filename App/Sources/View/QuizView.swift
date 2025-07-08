import SwiftUI

struct QuizView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingResults = false
    @State private var selectedChapter: MathChapter = .algebra
    @State private var showingQuizComplete = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Custom Header
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    Spacer()
                    Text("Math Quiz")
                        .font(.headline)
                    Spacer()
                    Text("        ") // Balance spacing
                }
                .padding(.horizontal)

                // Chapter Selection (Instagram Story Style) - Only show unlocked chapters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        let unlockedChapters = Array(quizViewModel.getUnlockedChapters())
                        let completedChapters = quizViewModel.getCompletedChapters()

                        ForEach(unlockedChapters, id: \.self) { chapter in
                            VStack {
                                Circle()
                                    .fill(selectedChapter == chapter ? Color.blue : Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        VStack {
                                            Text(chapter.rawValue.prefix(1))
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.primary)

                                            // Show checkmark if chapter is completed
                                            if completedChapters.contains(chapter) {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.caption2)
                                                    .foregroundColor(.green)
                                            }
                                        }
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(selectedChapter == chapter ? Color.blue : Color.clear, lineWidth: 3)
                                    )
                                    .onTapGesture {
                                        selectedChapter = chapter
                                        // Restart quiz with new chapter
                                        quizViewModel.startQuiz(chapter: selectedChapter)
                                    }

                                Text(chapter.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 10)

                if let quiz = quizViewModel.currentQuiz {
                    // Set the selected chapter to match the current quiz
                    let _ = DispatchQueue.main.async {
                        if let currentChapter = quiz.questions.first?.chapter {
                            selectedChapter = currentChapter
                        }
                    }

                    // Progress Bar
                    VStack(spacing: 8) {
                        HStack {
                            Text("Question \(quiz.currentQuestionIndex + 1) of \(quiz.questions.count)")
                                .font(.headline)
                            Spacer()
                            Text("Score: \(quiz.score)")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }

                        ProgressView(value: Double(quiz.currentQuestionIndex + 1), total: Double(quiz.questions.count))
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    }
                    .padding()

                    // Question Card
                    let currentQuestion = quiz.questions[quiz.currentQuestionIndex]

                    VStack(spacing: 15) {
                        // Question Image Placeholder
                        Rectangle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(height: 150)
                            .cornerRadius(10)
                            .overlay(
                                VStack {
                                    Image(systemName: "function")
                                        .font(.system(size: 40))
                                        .foregroundColor(.blue)
                                    Text(currentQuestion.chapter.rawValue)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            )

                        // Question Text
                        Text(currentQuestion.question)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 2)

                    // Answer Options
                    VStack(spacing: 10) {
                        ForEach(0 ..< currentQuestion.options.count, id: \.self) { index in
                            Button(action: {
                                quizViewModel.submitAnswer(index)
                            }) {
                                HStack {
                                    Text("\(["A", "B", "C", "D"][index])")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                        .background(Color.blue)
                                        .cornerRadius(15)

                                    Text(currentQuestion.options[index])
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.leading)

                                    Spacer()
                                }
                                .padding()
                                .background(
                                    quizViewModel.selectedAnswer == index ?
                                        Color.blue.opacity(0.2) : Color.gray.opacity(0.1)
                                )
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(quizViewModel.selectedAnswer == index ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Next/Finish Button
                    if quizViewModel.selectedAnswer != -1 {
                        Button(action: {
                            let result = quizViewModel.processAnswer()
                            if result.quizFinished {
                                showingQuizComplete = true
                            }
                        }) {
                            Text(quiz.currentQuestionIndex == quiz.questions.count - 1 ? "Finish Quiz" : "Continue")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                } else {
                    // No quiz loaded state
                    VStack {
                        Text("No quiz loaded")
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
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showingQuizComplete) {
                QuizResultView()
                    .environmentObject(quizViewModel)
            }
        }
    }
}
