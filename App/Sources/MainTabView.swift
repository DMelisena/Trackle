import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @State private var showingQuiz = false
    @State private var selectedDifficulty: Difficulty = .easy

    var body: some View {
        VStack(spacing: 20) {
            // App Title
            VStack {
                Image(systemName: "function")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding()

                Text("Trackle")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Master Mathematics Step by Step")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }

            // Difficulty Selection
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Difficulty")
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
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)

            // Progress Display
            VStack(spacing: 10) {
                Text("Your Progress")
                    .font(.headline)

                let unlockedChapterIndex = UserDefaults.standard.integer(forKey: "unlockedChapterIndex")
                let totalChapters = MathChapter.allCases.count

                HStack {
                    Text("Chapters Unlocked: \(unlockedChapterIndex + 1)/\(totalChapters)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }

                ProgressView(value: Double(unlockedChapterIndex + 1), total: Double(totalChapters))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)

            Spacer()

            // Start Test Button
            Button("Start Test") {
                // Start with the first available chapter
                let unlockedChapterIndex = UserDefaults.standard.integer(forKey: "unlockedChapterIndex")
                let firstChapter = MathChapter.allCases[0] // Always start with first chapter
                quizViewModel.startQuiz(chapter: firstChapter, difficulty: selectedDifficulty)
                showingQuiz = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .font(.headline)

            Spacer()
        }
        .padding()
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
