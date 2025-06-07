//
//  ContentView.swift
//  Dicey
//
//  Created by Toto on 06/06/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isRolling: Bool = false
    @State private var numberOfDice: Int = 1
    @State private var numberOfSides: Int = 6
    @State private var previousRolls: [RollResult] = []
    @State private var rollingValues: [Int] = []
    @State private var showingClearButton: Bool = false
    @State private var sides = [4, 6, 8, 10, 12, 20, 100]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Number of dice")
                    .font(.headline)
                Stepper(value: $numberOfDice, in: 1...4) {
                    Text("Dice: \(numberOfDice)")
                        .font(.headline)
                }
                .disabled(isRolling)
                .padding(.vertical)
                
                Text("Number of sides")
                    .font(.headline)
                Picker("Number of sides", selection: $numberOfSides) {
                    ForEach(sides, id: \.self) { side in
                        Text("\(side)")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top)
                
                Spacer()
                
                VStack {
                    HStack(spacing: 32) {
                        if rollingValues.isEmpty {
                            ForEach(0..<numberOfDice, id: \.self) { _ in
                                Text("100")
                                    .font(.system(size: 40))
                                    .opacity(0)
                            }
                        } else {
                            ForEach(rollingValues.indices, id: \.self) { index in
                                let currentRoll = rollingValues[index]
                                Text("\(currentRoll)")
                                    .font(.system(size: 40))
                                    .animation(.easeInOut(duration: 0.3), value: isRolling)
                                //                                Image("dice\(currentRoll)")
                                //                                    .resizable()
                                //                                    .scaledToFit()
                                //                                    .frame(height: isRolling ? 150 : 300)
                                //                                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                                //                                    .animation(.easeInOut(duration: 0.3), value: isRolling)
                            }
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                
                Button(isRolling ? "Roll again": "Roll dice", action: rollDice)
                    .buttonStyle(.borderedProminent)
                    .disabled(isRolling)
                
                Text(previousRolls.isEmpty ? "" : "Previous rolls: \(previousRolls.prefix(5).map { "\($0.total)" }.joined(separator: " | "))")
                    .padding(.top)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.4), value: previousRolls)
            }
            .onAppear(perform: loadRolls)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Clear", role: .destructive) {
                        showingClearButton = true
                    }
                    .opacity(previousRolls.isEmpty ? 0 : 1)
                    .disabled(previousRolls.isEmpty || isRolling)
                }
            }
            .alert("Clear history", isPresented: $showingClearButton) {
                Button("Delete", role: .destructive, action: removeRolls)
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure?")
            }
            .navigationTitle("Dicey")
            .padding()
        }
    }
    
    func rollDice() {
        isRolling = true
        var currentFrame = 0
        let totalFrames = 60
        var diceSum: Int = 0
        rollingValues = Array(repeating: 1, count: numberOfDice)
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if currentFrame <= totalFrames {
                for i in 0..<numberOfDice {
                    rollingValues[i] = Int.random(in: 1...numberOfSides)
                    diceSum = rollingValues.reduce(0, +)
                }
                currentFrame += 1
            } else {
                timer.invalidate()
                diceSum = rollingValues.reduce(0, +)
                let newResult = RollResult(total: diceSum)
                previousRolls.insert(newResult, at: 0)
                saveRolls(previousRolls)
                isRolling = false
            }
        }
    }
    
    func removeRolls() {
        previousRolls.removeAll()
        rollingValues.removeAll()
        isRolling = false
    }
    
    func saveRolls(_ rolls: [RollResult]) {
        let rollsUrl = URL.documentsDirectory.appending(path: "rolls.json")
        do {
            let data = try JSONEncoder().encode(rolls)
            try data.write(to: rollsUrl, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func loadRolls() {
        let rollsUrl = URL.documentsDirectory.appending(path: "rolls.json")
        guard let data = try? Data(contentsOf: rollsUrl) else {
            previousRolls = []
            return
        }
        
        if let decodedData = try? JSONDecoder().decode([RollResult].self, from: data) {
            previousRolls = decodedData
        }
    }
}

#Preview {
    ContentView()
}
