import SwiftUI

struct ChapterSelectionView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    
    @State private var showingQuiz = false
    @State private var unlockedChapterIndex: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                // Show only unlocked chapters
                List(0 ..< (unlockedChapterIndex + 1), id: \.self) { index in
                    let chapter = MathChapter.allCases[index]
                    Button(action: {
                        quizViewModel.startQuiz(chapter: chapter)
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
                .onChange(of: quizViewModel.lastQuizResult?.id) { _ in
                    loadUnlockedChapters()
                }
                
                

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

// MARK: - ChapterSelectionView Preview
struct ChapterSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChapterSelectionView()
                .environmentObject(QuizViewModel())
                .previewDisplayName("ChapterSelectionView")
            
            ChapterSelectionView()
                .environmentObject(QuizViewModel())
                .onAppear {
                    UserDefaults.standard.set(3, forKey: "unlockedChapterIndex")
                }
                .previewDisplayName("ChapterSelectionView - Progress")
            
            ChapterSelectionView()
                .environmentObject(QuizViewModel())
                .previewDevice("iPad Pro (12.9-inch) (6th generation)")
                .previewDisplayName("ChapterSelectionView - iPad")
        }
    }
}
//struct ChapterSelectionView_ProgressPreviews: PreviewProvider { //    static var previews: some View { //        Group {
//            ChapterSelectionView()
//                .environmentObject(QuizViewModel())
//                .onAppear {
//                    UserDefaults.standard.set(0, forKey: "unlockedChapterIndex")
//                }
//                .previewDisplayName("Just Started")
//
//            ChapterSelectionView()
//                .environmentObject(QuizViewModel())
//                .onAppear {
//                    UserDefaults.standard.set(2, forKey: "unlockedChapterIndex")
//                }
//                .previewDisplayName("Mid Progress")
//
//            ChapterSelectionView()
//                .environmentObject(QuizViewModel())
//                .onAppear {
//                    UserDefaults.standard.set(4, forKey: "unlockedChapterIndex")
//                }
//                .previewDisplayName("Almost Complete")
//        }
//    }
//}

