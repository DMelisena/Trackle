import SwiftUI

struct ContentView2: View {
    @StateObject private var quizViewModel = QuizViewModel()

    var body: some View {
        MainTabView()
            .environmentObject(quizViewModel)
    }
}
