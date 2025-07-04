
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var quizViewModel: QuizViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Welcome Card
                VStack(alignment: .leading, spacing: 10) {
                    Text("Welcome back,")
                        .font(.title2)
                        .foregroundColor(.secondary)

                    Text(authViewModel.currentUser?.name ?? "User")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Role: \(authViewModel.currentUser?.role.rawValue ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)

                // Statistics Cards
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                    StatCard(title: "Total Questions", value: "\(quizViewModel.mathQuestions.count)", color: .green)
                    StatCard(title: "Chapters", value: "\(MathChapter.allCases.count)", color: .orange)
                    StatCard(title: "Your Results", value: "\(quizViewModel.getResults(for: authViewModel.currentUser?.username ?? "").count)", color: .purple)
                    StatCard(title: "Average Score", value: "\(averageScore())%", color: .red)
                }

                Spacer()

                // Quick Actions
                VStack(spacing: 10) {
                    Text("Quick Actions")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    NavigationLink(destination: QuizSelectionView()) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                            Text("Start New Quiz")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Dashboard")
            .navigationBarItems(
                trailing: Button("Logout") {
                    authViewModel.logout()
                }
            )
        }
    }

    private func averageScore() -> Int {
        let results = quizViewModel.getResults(for: authViewModel.currentUser?.username ?? "")
        guard !results.isEmpty else { return 0 }

        let totalScore = results.reduce(0) { $0 + ($1.score * 100 / $1.totalQuestions) }
        return totalScore / results.count
    }
}
