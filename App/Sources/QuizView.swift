import SwiftUI

struct QuizView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingResults = false
    @State private var selectedChapter: MathChapter = .algebra // Add selectedChapter state

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
                    // Placeholder to balance the layout if needed, or remove if not
                    Text("        ") // Adjust spacing as needed
                }
                .padding(.horizontal)

                // Chapter Selection (Instagram Story Style)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(MathChapter.allCases, id: \.self) {
                            chapter in
                            VStack {
                                Circle()
                                    .fill(selectedChapter == chapter ? Color.blue : Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Text(chapter.rawValue.prefix(1))
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(selectedChapter == chapter ? Color.blue : Color.clear, lineWidth: 3)
                                    )
                                    .onTapGesture {
                                        selectedChapter = chapter
                                        // Restart quiz with new chapter and current difficulty
                                        quizViewModel.startQuiz(chapter: selectedChapter, difficulty: quizViewModel.currentQuiz?.questions.first?.difficulty ?? .easy)
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
                            if quiz.currentQuestionIndex < quiz.questions.count - 1 {
                                quizViewModel.nextQuestion()
                            } else {
                                quizViewModel.finishQuiz(userId: "guest")
                                showingResults = true
                            }
                        }) {
                            Text(quiz.currentQuestionIndex < quiz.questions.count - 1 ? "Next Question" : "Finish Quiz")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true) // Hide the default navigation bar
            .fullScreenCover(isPresented: $showingResults) {
                QuizResultView()
                    .environmentObject(quizViewModel)
            }
        }
    }
}
