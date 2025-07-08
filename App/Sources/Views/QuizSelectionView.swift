import SwiftUI

struct QuizSelectionView: View {
    @StateObject private var viewModel = QuizSelectionViewModel()
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

            // Selectors for Chapter and Difficulty
            VStack(alignment: .leading, spacing: 10) {
                Picker("Chapter", selection: $viewModel.selectedChapter) {
                    ForEach(MathChapter.allCases, id: \.self) { chapter in
                        Text(chapter.rawValue).tag(chapter)
                    }
                }
                .pickerStyle(.wheel)
                .padding(.horizontal)

                Picker("Difficulty", selection: $viewModel.selectedDifficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue).tag(difficulty)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
            }

            

            // Question Count Preview
            Text("Available Questions: \(viewModel.questionCount)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            // Start Quiz Button
            Button("Start Quiz") {
                showingQuiz = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.questionCount > 0 ? Color.blue : Color.gray)
            .foregroundColor(.primary)
            .cornerRadius(10)
            .disabled(viewModel.questionCount == 0)

            if viewModel.questionCount == 0 {
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
            QuizView(viewModel: viewModel.createQuizViewModel())
        }
    }

    
}

#Preview {
    QuizSelectionView()
}
