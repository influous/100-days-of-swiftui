//
//  ContentView.swift
//  WeRPS
//
//  Created by Tobias on 15/01/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var currentRound = 1
    @State private var noOfRounds = 10
    @State private var score = 0
    
    @State private var opponentMoves = ["🪨", "📃", "✂️"]
    @State private var winningMoves = ["📃", "✂️", "🪨"]
    
    @State private var opponentChoice = Int.random(in:0...2)
    @State private var currentChoice = ""
    @State private var shouldWin = Bool.random()
    
    @State private var scoreTitle = ""
    @State private var gameIsOver = false
    @State private var showingScore = false
    
    struct MoveView: View {
        var move: String
        
        var body: some View {
            Text(move)
                .font(.system(size: 100))
        }
    }
    
    var body: some View {
        ZStack() {
            LinearGradient(colors: [Color.red, Color.blue], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            VStack {
                Text("WeRPS")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Spacer()

                VStack(spacing: 15) {
                    Text("Opponent plays")
                        .font(.largeTitle.weight(.semibold))
                    MoveView(move: opponentMoves[opponentChoice])
                
                
                // shouldWin ? Text("You need to win") : Text("You need to lose")
                if shouldWin {
                    Text("✨You need to win✨")
                        .foregroundStyle(.primary)
                        .font(.title.weight(.heavy))
                } else {
                    Text("✨You need to lose✨")
                        .foregroundStyle(.primary)
                        .font(.title.weight(.heavy))
                }
                }
                Spacer()
                Spacer()
                HStack {
                    ForEach(0..<3) { ourChoice in Button {
                        choiceTapped(ourChoice)
                    } label: {
                        MoveView(move: winningMoves[ourChoice])
                    }
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding(5)
                    }
                    
                }
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
            }
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Current score: \(score)")
            }
            .alert("Game Over", isPresented: $gameIsOver) {
                Button("Here We Go Again...", action: resetGame)
            } message: {
                Text("Your final score: \(score)")
            }
            //.padding()
        }
    }
    func choiceTapped(_ ourChoice: Int) {
        print("Round number: \(currentRound)")
        if shouldWin {
            if winningMoves.firstIndex(of: winningMoves[ourChoice]) == opponentMoves.firstIndex(of: opponentMoves[opponentChoice]) {
                scoreTitle = "Correct! 🎉"
                score += 1
            } else {
                scoreTitle = "Nope. You picked \(winningMoves[ourChoice])"
            }
        } else {
            if winningMoves[ourChoice] == opponentMoves[opponentChoice]  {
                scoreTitle = "Nope. You picked \(winningMoves[ourChoice])"
            } else if winningMoves.firstIndex(of: winningMoves[ourChoice]) != opponentMoves.firstIndex(of: opponentMoves[opponentChoice]) {
                scoreTitle = "Correct"
                score += 1
            } else {
                scoreTitle = "Nope. You picked \(winningMoves[ourChoice])"
            }
        }

        showingScore = true
        
        if currentRound >= noOfRounds {
            gameIsOver = true
        }
        currentRound += 1
    }

    func resetGame() {
        opponentChoice = Int.random(in: 0...2)
        score = 0
        currentRound = 1
    }
    
    func askQuestion() {
        opponentChoice = Int.random(in: 0...2)
        shouldWin.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
