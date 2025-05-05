//
//  ContentView.swift
//  Moonshot
//
//  Created by Tobias on 01/02/2025.
//

import SwiftUI

// @Observable

struct ContentView: View {
    @State private var showingGrid = true
    @State private var path = NavigationPath()
    
    let astronauts: [String:Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
//        Text(String(astronauts.count))
        NavigationStack(path: $path) {
            ScrollView {
                Group {
                    NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
                    
                    if showingGrid {
                        GridLayout(astronauts: astronauts, missions: missions)
                            .padding([.horizontal, .bottom])
                    } else {
                        ListLayout(astronauts: astronauts, missions: missions)
                            .padding([.horizontal, .bottom])
                    }
                }
            }

            
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                Button(showingGrid ? "Toggle List" : "Toggle Grid") {
                    showingGrid.toggle()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
