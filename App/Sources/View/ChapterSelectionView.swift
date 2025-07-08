import SwiftUI

struct ChapterSelectionView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    
    @State private var showingQuiz = false
    @State private var unlockedChapters: Set<MathChapter> = []
    @State private var completedChapters: Set<MathChapter> = []

    var body: some View {
        NavigationView {
            VStack {
                // Chapter Tree View
                ScrollView {
                    VStack(spacing: 30) {
                        ForEach(MathChapter.allCases, id: \.self) { chapter in
                            if unlockedChapters.contains(chapter) || completedChapters.contains(chapter) {
                                chapterRow(for: chapter)
                            }
                        }
                    }
                    .padding()
                }
                
                // Progress Display
                VStack(spacing: 10) {
                    Text("Your Progress")
                        .font(.headline)
                    
                    HStack {
                        Text("Chapters Completed: \(completedChapters.count)/\(MathChapter.allCases.count)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    
                    ProgressView(value: Double(completedChapters.count), total: Double(MathChapter.allCases.count))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .navigationTitle("Math Chapters")
            .onAppear(perform: loadChapterStatus)
            .onReceive(NotificationCenter.default.publisher(for: .chapterUnlocked)) { _ in
                loadChapterStatus()
            }
            .fullScreenCover(isPresented: $showingQuiz) {
                QuizView()
                    .environmentObject(quizViewModel)
            }
        }
    }
    
    @ViewBuilder
    private func chapterRow(for chapter: MathChapter) -> some View {
        Button(action: {
            if unlockedChapters.contains(chapter) {
                quizViewModel.startQuiz(chapter: chapter)
                showingQuiz = true
            }
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(chapter.rawValue)
                        .font(.headline)
                        .foregroundColor(unlockedChapters.contains(chapter) ? .primary : .secondary)
                    
                    
                }
                
                Spacer()
                
                // Status Icon
                if completedChapters.contains(chapter) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                } else if unlockedChapters.contains(chapter) {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                } else {
                    Image(systemName: "lock.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(chapterBackgroundColor(for: chapter))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(chapterBorderColor(for: chapter), lineWidth: 2)
            )
        }
        .disabled(!unlockedChapters.contains(chapter))
    }
    
    private func chapterBackgroundColor(for chapter: MathChapter) -> Color {
        if completedChapters.contains(chapter) {
            return Color.green.opacity(0.1)
        } else if unlockedChapters.contains(chapter) {
            return Color.blue.opacity(0.1)
        } else {
            return Color.gray.opacity(0.1)
        }
    }
    
    private func chapterBorderColor(for chapter: MathChapter) -> Color {
        if completedChapters.contains(chapter) {
            return Color.green.opacity(0.3)
        } else if unlockedChapters.contains(chapter) {
            return Color.blue.opacity(0.3)
        } else {
            return Color.gray.opacity(0.3)
        }
    }

    func loadChapterStatus() {
        completedChapters = quizViewModel.getCompletedChapters()
        unlockedChapters = quizViewModel.getUnlockedChapters()
    }
}

extension Notification.Name {
    static let chapterUnlocked = Notification.Name("chapterUnlocked")
}
