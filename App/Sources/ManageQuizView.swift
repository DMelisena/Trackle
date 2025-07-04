//
//  ManageQuizView.swift
//  Trackle
//
//  Created by Arya Hanif on 04/07/25.
//
import SwiftUI

struct ManageQuizView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @State private var showingAddQuestionSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Existing Questions")) {
                    if quizViewModel.mathQuestions.isEmpty {
                        Text("No questions added yet.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(quizViewModel.mathQuestions) { question in
                            VStack(alignment: .leading) {
                                Text(question.question)
                                    .font(.headline)
                                Text("Chapter: \(question.chapter.rawValue), Difficulty: \(question.difficulty.rawValue)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Correct Answer: \(question.options[question.correctAnswer])")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        .onDelete(perform: deleteQuestion)
                    }
                }
            }
            .navigationTitle("Manage Questions")
            .navigationBarItems(
                trailing: Button(action: {
                    showingAddQuestionSheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            )
            .sheet(isPresented: $showingAddQuestionSheet) {
                AddQuestionView()
                    .environmentObject(quizViewModel)
            }
        }
    }
    
    private func deleteQuestion(at offsets: IndexSet) {
        quizViewModel.mathQuestions.remove(atOffsets: offsets)
    }
}
