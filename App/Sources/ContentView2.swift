import SwiftUI

struct ContentView2: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var quizViewModel = QuizViewModel()

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                MainTabView()
                    .environmentObject(authViewModel)
                    .environmentObject(quizViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
