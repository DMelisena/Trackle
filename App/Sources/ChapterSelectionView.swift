import SwiftUI

struct ChapterSelectionView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var showingQuiz = false
    @State private var unlockedChapters: [MathChapter] = []

    var body: some View {
        NavigationView {
            VStack {
                List(unlockedChapters, id: \.self) { chapter in
                    Button(action: {
                        quizViewModel.startQuiz(chapter: chapter, difficulty: selectedDifficulty)
                        showingQuiz = true
                    }) {
                        Text(chapter.rawValue)
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
            }
            .navigationTitle("Select a Chapter")
            .fullScreenCover(isPresented: $showingQuiz) {
                QuizView()
                    .environmentObject(quizViewModel)
            }
        }
    }

    func loadUnlockedChapters() {
        let unlockedChapterIndex = UserDefaults.standard.integer(forKey: "unlockedChapterIndex")
        unlockedChapters = Array(MathChapter.allCases.prefix(unlockedChapterIndex + 1))
    }
}
