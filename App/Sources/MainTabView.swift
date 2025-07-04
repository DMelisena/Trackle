import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var quizViewModel: QuizViewModel

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Dashboard")
                }

            QuizSelectionView()
                .tabItem {
                    Image(systemName: "questionmark.circle")
                    Text("Quiz")
                }

            ResultsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Results")
                }

            if authViewModel.currentUser?.role == .teacher {
                ManageQuizView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Manage")
                    }
            }
        }
        .environmentObject(authViewModel)
        .environmentObject(quizViewModel)
    }
}
