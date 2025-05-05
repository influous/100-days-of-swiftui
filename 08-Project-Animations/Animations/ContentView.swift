//
//  ContentView.swift
//  Animations
//
//  Created by Tobias on 20/01/2025.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    
    @State private var animationAmount = 1.0
    @State private var buttonEnabled = false
    @State private var textEnabled = false
    @State private var dragAmount = CGSize.zero
    @State private var isShowingRed = false
    
    let letters = Array("Hello SwiftUI")
    
    var body: some View {
        //        VStack {
        //            Button("Tap Me") {
        //                // animationAmount += 1
        //            }
        //            .padding(50)
        //            .background(.red)
        //            .foregroundStyle(.white)
        //            .clipShape(Circle())
        //            .overlay(
        //                Circle()
        //                    .stroke(.red)
        //                    .scaleEffect(animationAmount)
        //                    .opacity(2 - animationAmount)
        //                    .animation(
        //                        .easeInOut(duration: 1)
        //                            .repeatForever(autoreverses: false),
        //                        value: animationAmount
        //                    )
        //            )
        //            .onAppear {
        //                animationAmount = 2
        //            }
        //        }
        VStack {
            Button("Tap Me") {
                buttonEnabled.toggle()
            }
            .padding(40)
            .background(buttonEnabled ? .blue : .red)
            .animation(.default, value: buttonEnabled)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: buttonEnabled ? 60 : 0))
            .animation(.spring(response: 1, dampingFraction: 0.6), value: buttonEnabled)
            
            LinearGradient(colors: [.yellow, .red], startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 300, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .offset(dragAmount)
                .gesture(
                    DragGesture()
                        .onChanged { dragAmount = $0.translation }
                        .onEnded { _ in
                            withAnimation(.interpolatingSpring(stiffness: 350, damping: 25, initialVelocity: 10)) { // in newer Xcode, use .bouncy instead of .interpolatingSpring
                                dragAmount = .zero
                            }
                            
                        }
                )
            // .animation(.interpolatingSpring(stiffness: 350, damping: 5, initialVelocity: 10), value: dragAmount) // in newer Xcode, use .bouncy instead of .interpolatingSpring
            
            HStack(spacing: 0) {
                ForEach(0..<letters.count, id: \.self) { num in
                    Text(String(letters[num]))
                        .padding(5)
                        .font(.title)
                        .background(textEnabled ? .blue : .red)
                        .offset(dragAmount)
                        .animation(.linear.delay(Double(num) / 20), value: dragAmount)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in
                        dragAmount = .zero
                        textEnabled.toggle()
                    }
            )
            
            Button(isShowingRed ? "Hide Red": "Show Red") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    // .transition(.scale)
                    // .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
