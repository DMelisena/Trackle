import SwiftUI
struct ResultsView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var selectedChapter: MathChapter? = nil
    @State private var selectedDifficulty: Difficulty? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                if let userId = authViewModel.currentUser?.username {
                    let filteredResults = quizViewModel.getResults(for: userId, chapter: selectedChapter, difficulty: selectedDifficulty)
                    
                    Picker("Chapter", selection: $selectedChapter) {
                        Text("All Chapters").tag(nil as MathChapter?)
                        ForEach(MathChapter.allCases, id: \.self) { chapter in
                            Text(chapter.rawValue).tag(chapter as MathChapter?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                    
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        Text("All Difficulties").tag(nil as Difficulty?)
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.rawValue).tag(difficulty as Difficulty?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                    
                    List {
                        if filteredResults.isEmpty {
                            Text("No results found for your selection.")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(filteredResults) { result in
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Chapter: \(result.chapter.rawValue) - \(result.difficulty.rawValue)")
                                        .font(.headline)
                                    Text("Score: \(result.score)/\(result.totalQuestions) (\((result.score * 100) / result.totalQuestions)%)")
                                        .font(.subheadline)
                                        .foregroundColor(scoreColor((result.score * 100) / result.totalQuestions))
                                    Text("Date: \(result.date, formatter: itemFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("Time Spent: \(formatTime(result.timeSpent))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                } else {
                    Text("Please log in to view your results.")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Your Results")
        }
    }
    
    private func scoreColor(_ percentage: Int) -> Color {
        if percentage >= 80 {
            return .green
        } else if percentage >= 50 {
            return .orange
        } else {
            return .red
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timeInterval) ?? "0s"
    }
    
    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}
