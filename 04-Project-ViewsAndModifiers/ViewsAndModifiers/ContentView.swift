//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Tobias on 13/01/2025.
//

import SwiftUI

// Custom modifier example 1
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundStyle(.white)
            .padding()
            .background(.indigo)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

// Custom modifier example 2
struct Watermark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}

struct ContentView: View {
    @State private var useRedText = false
    
    struct GridStack<Content: View>: View {
        let rows: Int
        let columns: Int
        @ViewBuilder let content: (Int, Int) -> Content // using @ViewBuilder allows to implicitly create an HStack inside cell closure below
        
        var body: some View {
            VStack {
                ForEach(0..<rows, id: \.self) { row in
                    HStack {
                        ForEach(0..<columns, id: \.self) { column in
                            content(row, column)
                        }
                    }
                }
            }
        }
    }
    
    // View composition example
    struct CapsuleText: View {
        var text: String
        
        var body: some View {
            Text(text)
                .font(.subheadline)
                .padding()
            // .foregroundStyle(.white)
                .background(.blue)
                .clipShape(Capsule())
        }
    }
    
    // Computed properties example
    @ViewBuilder var spells: some View {
        Text("Lumos")
        Text("Obliviate")
    }
    
    var body: some View {
        
        // Custom container - don't need to wrap the GridStack into an HStack anymore - see GridStack declaration above
        GridStack(rows: 4, columns: 4) { row, col in
            Image(systemName: "\(row * 4 + col).circle")
            Text("R\(row) C\(col)")
        }
            
            VStack {
                // Reference custom modfiier
                Color.blue
                    .frame(width: 300, height: 100)
                    .watermarked(with: "Hacking with Swift")
                
                // Reference computed property
                spells
                    .foregroundStyle(.indigo)
                
                Text("Text with custom modifier")
                    .titleStyle()
                
                // Reference composition
                VStack {
                    CapsuleText(text: "CapsuleText1")
                        .foregroundStyle(.green)
                    CapsuleText(text: "CapsuleText2")
                        .foregroundStyle(.red)
                }
                
                Text("Gryffindor")
                    .font(.largeTitle) // local modifiers override environment modifiers
                Text("Hufflepuff")
                    .blur(radius: 5)
                Text("Ravenclaw")
                Text("Slytherin")
                
                Button("Button changing color") {
                    print(type(of: self.body))
                    useRedText.toggle()
                }
                .foregroundStyle(useRedText ? .red : .blue)
                .background(.black)
                .padding()
                
                Text("Hello, world!")
                    .background(.red)
                    .padding()
                    .padding()
                    .background(.blue)
                    .padding()
                    .background(.green)
                    .padding()
                    .background(.yellow)
            }
            .fontWeight(.semibold) // environment modifier
        }
        
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
