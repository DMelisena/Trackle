//
//  AddQuestionView.swift
//  Trackle
//
//  Created by Arya Hanif on 04/07/25.
//
import SwiftUI

struct AddQuestionView: View {
    @EnvironmentObject var quizViewModel: QuizViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var questionText: String = ""
    @State private var option1: String = ""
    @State private var option2: String = ""
    @State private var option3: String = ""
    @State private var option4: String = ""
    @State private var correctAnswerIndex: Int = 0
    @State private var selectedChapter: MathChapter = .algebra
    @State private var selectedDifficulty: Difficulty = .easy
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Question Details")) {
                    TextField("Question", text: $questionText)
                    
                    Picker("Chapter", selection: $selectedChapter) {
                        ForEach(MathChapter.allCases, id: \.self) { chapter in
                            Text(chapter.rawValue).tag(chapter)
                        }
                    }
                    
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.rawValue).tag(difficulty)
                        }
                    }
                }
                
                Section(header: Text("Options")) {
                    TextField("Option A", text: $option1)
                    TextField("Option B", text: $option2)
                    TextField("Option C", text: $option3)
                    TextField("Option D", text: $option4)
                }
                
                Section(header: Text("Correct Answer")) {
                    Picker("Correct Answer", selection: $correctAnswerIndex) {
                        Text("Option A").tag(0)
                        Text("Option B").tag(1)
                        Text("Option C").tag(2)
                        Text("Option D").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Button("Add Question") {
                    addQuestion()
                }
                .disabled(questionText.isEmpty || option1.isEmpty || option2.isEmpty || option3.isEmpty || option4.isEmpty)
            }
            .navigationTitle("Add New Question")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") { dismiss() })
            .alert("Add Question", isPresented: $showingAlert) {
                Button("OK") {
                    if alertMessage.contains("successfully") {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func addQuestion() {
        let newQuestion = MathQuestion(
            chapter: selectedChapter,
            difficulty: selectedDifficulty,
            imageName: "", // Placeholder, as image handling is not implemented
            question: questionText,
            options: [option1, option2, option3, option4],
            correctAnswer: correctAnswerIndex
        )
        quizViewModel.addQuestion(newQuestion)
        alertMessage = "Question added successfully!"
        showingAlert = true
    }
}
