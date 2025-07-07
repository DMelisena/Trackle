import SwiftUI

struct ChapterSelectionView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var showingQuiz = false
    @State private var unlockedChapterIndex: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                // Show only unlocked chapters
                List(0 ..< (unlockedChapterIndex + 1), id: \.self) { index in
                    let chapter = MathChapter.allCases[index]
                    Button(action: {
                        quizViewModel.startQuiz(chapter: chapter, difficulty: selectedDifficulty)
                        showingQuiz = true
                    }) {
                        HStack {
                            Text(chapter.rawValue)
                                .font(.headline)
                            Spacer()
                            if index == unlockedChapterIndex {
                                Image(systemName: "play.circle.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onAppear(perform: loadUnlockedChapters)

                Picker("Difficulty", selection: $selectedDifficulty) {
                    ForEach(Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Show progress
                Text("Progress: \(unlockedChapterIndex + 1)/\(MathChapter.allCases.count) chapters")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
            .navigationTitle("Math Chapters")
            .fullScreenCover(isPresented: $showingQuiz) {
                QuizView()
                    .environmentObject(quizViewModel)
            }
            .onReceive(NotificationCenter.default.publisher(for: .chapterUnlocked)) { _ in
                loadUnlockedChapters()
            }
        }
    }

    func loadUnlockedChapters() {
        unlockedChapterIndex = UserDefaults.standard.integer(forKey: "unlockedChapterIndex")
        // Ensure we don't go beyond available chapters
        unlockedChapterIndex = min(unlockedChapterIndex, MathChapter.allCases.count - 1)
    }
}

extension Notification.Name {
    static let chapterUnlocked = Notification.Name("chapterUnlocked")
}
