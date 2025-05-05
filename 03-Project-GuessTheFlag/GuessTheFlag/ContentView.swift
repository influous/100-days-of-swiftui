//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Tobias on 11/01/2025.
//

import SwiftUI

struct Title: ViewModifier { // Day 24 challenge
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundStyle(.blue)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var selectedAnswer = 0
    
    @State private var showingScore = false
    @State private var gameIsOver = false
    
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var round = 1
    
    @State private var rotationAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var scaleAmount = 1.0
    @State private var isFullyVisible = true
    
    struct FlagView: View {
        var flag: String
        
        var body: some View {
            Image(flag)
                .clipShape(Capsule()) // .capsule
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        ZStack() {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .titleStyle()
                VStack(spacing: 15) {
                    VStack() {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    ForEach(0..<3) { number in Button {
                        flagTapped(number)
                    } label: {
                        FlagView(flag: countries[number]) // Day 24 challenge - before: Image(countries[number])
                    }
                    .rotation3DEffect(.degrees(number == selectedAnswer ? rotationAmount : 0), axis: (x: 0, y: 1, z: 0)) // Day 34 challenge
                    .opacity(isFullyVisible ?
                             1.0 : (number == correctAnswer ? 1.0 : opacityAmount)) // Day 34 challenge
                    .scaleEffect(number == correctAnswer ? 1.0 : scaleAmount) // Day 34 challenge
                    .animation(.default, value: scaleAmount) // Day 34 challenge
                    }
                }
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Current score: \(score)")
            }
            .alert("Game Over", isPresented: $gameIsOver) {
                Button("New Game", action: resetGame)
            } message: {
                Text("Final score: \(score)")
            }
            .padding()
        }
    }
    
    func flagTapped(_ number: Int) {
        
        selectedAnswer = number
        
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong. You picked \(countries[number])."
        }
        
        withAnimation { // Day 34 challenge
            rotationAmount = 360
            scaleAmount = 0.5
            opacityAmount = 0.25
            isFullyVisible = false
        }
        
        showingScore = true
        
        if round >= 8 {
            gameIsOver = true
        }
        round += 1
    }
    
    func resetGame() {
        score = 0
        round = 1
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        // Day 34 challenge - resets animation values back to their initial values
        rotationAmount = 0.0
        opacityAmount = 1.0
        scaleAmount = 1.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
