import SwiftUI

struct MainTabView: View {
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

                Text("Trackle")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Master Mathematics Step by Step")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }

            

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
                quizViewModel.startQuiz(chapter: firstChapter)
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

    
}
