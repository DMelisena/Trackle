import SwiftUI

struct ContentView: View {
    @StateObject private var quizViewModel = QuizViewModel()

    var body: some View {
        MainTabView()
            .environmentObject(quizViewModel)
            .ignoresSafeArea()
    }
}
