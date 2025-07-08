import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @State private var showingQuiz = false
    @State private var showingChapterSelection = false

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

                let completedChapters = quizViewModel.getCompletedChapters()
                let totalChapters = MathChapter.allCases.count

                HStack {
                    Text("Chapters Completed: \(completedChapters.count)/\(totalChapters)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }

                ProgressView(value: Double(completedChapters.count), total: Double(totalChapters))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))

                // Show unlocked chapters
                let unlockedChapters = quizViewModel.getUnlockedChapters()
                if !unlockedChapters.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Available Chapters:")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(unlockedChapters.map { $0.rawValue }.joined(separator: ", "))
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)

            Spacer()

            // Action Buttons
            VStack(spacing: 15) {
                // Start Test Button (for Algebra or next available chapter)
                Button("Start Test") {
                    let unlockedChapters = quizViewModel.getUnlockedChapters()
                    if unlockedChapters.contains(.algebra) {
                        // Start with Algebra if available
                        quizViewModel.startQuiz(chapter: .algebra)
                        showingQuiz = true
                    } else if let firstUnlocked = unlockedChapters.first {
                        // Start with first available chapter
                        quizViewModel.startQuiz(chapter: firstUnlocked)
                        showingQuiz = true
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(quizViewModel.getUnlockedChapters().isEmpty ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(.headline)
                .disabled(quizViewModel.getUnlockedChapters().isEmpty)

                // Chapter Selection Button
                Button("View All Chapters") {
                    showingChapterSelection = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(.headline)
            }

            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingQuiz) {
            QuizView()
                .environmentObject(quizViewModel)
        }
        .sheet(isPresented: $showingChapterSelection) {
            ChapterSelectionView()
                .environmentObject(quizViewModel)
        }
    }
}
