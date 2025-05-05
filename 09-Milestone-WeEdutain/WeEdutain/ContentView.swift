//
//  ContentView.swift
//  WeEdutain
//
//  Created by Tobias on 25/01/2025.
//

import SwiftUI

struct Question: Identifiable {
    let id = UUID()
    let question: String
    let answer: Int
    var userAnswer: String = ""
    var isCorrect: Bool = false
}

struct ContentView: View {
    
    @State private var difficulty = ["Easy", "Medium", "Hard"]
    @State private var chosenDifficulty = "Easy"
    @State private var easyRange = Int.random(in: 2...5)
    @State private var mediumRange = Int.random(in: 6...9)
    @State private var hardRange = Int.random(in: 10...12)
    @State private var gameIsActive = false
    @State private var score = 0
    @State private var chosenRange = 2
    
    @FocusState private var textFieldIsFocused: Bool
    
    @State private var questionCount: Int = 5
    @State private var questions: [Question] = []
    
    var body: some View {
        VStack {
            Text("Which multiplication tables do you want to practice?")
            
            Stepper("Number of Questions: \(questionCount)", value: $questionCount, in: 5...20, step: 5)
                .padding()
            
            Picker("Questions?", selection: $chosenDifficulty) {
                ForEach(difficulty, id: \.self) { value in
                    Text(value)
                }
            }
            
            Text(displayMessage(for: chosenDifficulty))
            
            Button("Generate Questions") {
                generateQuestions(count: questionCount)
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            List {
                ForEach($questions) { $question in
                    VStack(alignment: .leading) {
                        Text(question.question)
                            .font(.headline)
                        TextField("Answer", text: $question.userAnswer)
                        
                            .onSubmit {
                                print("submitted")
                            }
                            
                            .onChange(of: question.userAnswer) { newValue in
                                // print(newValue)
                                if question.userAnswer == String(question.answer) {
                                    print("correct")
                                    question.isCorrect = true //TODO: withAnimation confetti, jump to next field, make correct field disappear
                                    // textFieldIsFocused = false
                                }
                            }
                            .keyboardType(.numberPad)
                            //.focused($textFieldIsFocused)
                            .disabled(question.isCorrect)
                        Text("Answer: \(question.answer)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
    }
    
    func displayMessage(for option: String) -> String {
        switch option {
        case "Easy":
            return "Tables of 2 to 5"
        case "Medium":
            return "Tables of 6 to 9"
        case "Hard":
            return "Tables of 9 to 12"
        default:
            return "Invalid selection"
        }
    }
    
    func generateQuestions(count: Int) {
        questions = (1...count).map { _ in
            let x = Int.random(in: 1...10)
            var y = chosenRange
            
            switch chosenDifficulty {
            case "Easy":
                y = Int.random(in: 2...5)
            case "Medium":
                y = Int.random(in: 6...9)
            case "Hard":
                y = Int.random(in: 10...12)
            default:
                y = chosenRange
            }
            
            return Question(
                question: "What is \(x) x \(y)?",
                answer: x * y
            )
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
