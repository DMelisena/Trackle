import SwiftUI

struct QuizSelectionView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
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

            // Question Count Preview
            let questionCount = quizViewModel.mathQuestions.count

            Text("Available Questions: \(questionCount)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            // Start Quiz Button
            Button("Start Quiz") {
                // Start with the first chapter by default
                quizViewModel.startQuiz(chapter: MathChapter.allCases.first ?? .algebra)
                showingQuiz = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(questionCount > 0 ? Color.blue : Color.gray)
            .foregroundColor(.primary)
            .cornerRadius(10)
            .disabled(questionCount == 0)

            if questionCount == 0 {
                Text("No questions available")
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
}

struct QuizSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QuizSelectionView()
                .environmentObject(QuizViewModel())
                .previewDisplayName("QuizSelectionView")

            QuizSelectionView()
                .environmentObject(QuizViewModel())
                .preferredColorScheme(.dark)
                .previewDisplayName("QuizSelectionView - Dark")
        }
    }
}
