import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel

    var body: some View {
        ChapterSelectionView()
            .environmentObject(quizViewModel)
    }
}
