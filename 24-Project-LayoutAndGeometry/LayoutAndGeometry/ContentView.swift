//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Toto on 01/06/2025.
//

import SwiftUI

struct OuterView: View {
    var body: some View {
        VStack {
            Text("Top")
            InnerView()
                .background(.green)
            Text("Bottom")
        }
    }
}

struct InnerView: View {
    var body: some View {
        HStack {
            Text("Left")
            GeometryReader { proxy in
                Text("Center")
                    .background(.blue)
                    .onTapGesture {
                        print("Global center: \(proxy.frame(in: .global).midX) x \(proxy.frame(in: .global).midY)")
                        print("Custom center: \(proxy.frame(in: .named("Custom")).midX) x \(proxy.frame(in: .named("Custom")).midY)")
                        print("Local center: \(proxy.frame(in: .local).midX) x \(proxy.frame(in: .local).midY)")
                    }
            }
            .background(.orange)
            Text("Right")
        }
    }
}

struct ContentView: View {
    @State private var offset = CGSize.zero
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { proxy in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(    
                                Color(
                                    hue: calculateHue(
                                        scrollOffset: proxy.frame(in: .global).minY,
                                        index: index
                                    ),
                                    saturation: 1,
                                    brightness: 1
                                )
                            )
                            .rotation3DEffect(.degrees(proxy.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            .opacity(calculateOpacity(proxy: proxy, outerProxy: fullView))
                            .scaleEffect(calculateScale(proxy: proxy, outerProxy: fullView))
                    }
                    .padding(.top, 40)
                    .frame(height: 40)
                }
            }
        }

    }
    
    func calculateOpacity(proxy: GeometryProxy, outerProxy: GeometryProxy) -> Double { // Challenge 1
        let fadeStart: CGFloat = outerProxy.safeAreaInsets.top - 20.0
        let fadeEnd = 0.0
        
        let itemTop = proxy.frame(in: .global).minY
        let outerProxyTop = outerProxy.frame(in: .global).minY
        let relativePosition = itemTop - outerProxyTop
        
        if relativePosition >= fadeStart {
            return 1.0
        } else if relativePosition <= fadeEnd {
            return 0.0
        } else {
            return Double((relativePosition - fadeEnd) / (fadeStart - fadeEnd))
        }
    }
    
    func calculateScale(proxy: GeometryProxy, outerProxy: GeometryProxy) -> CGFloat { // Challenge 2
        let outerProxyHeight = outerProxy.size.height
        let itemPosition = proxy.frame(in: .global).minY
        let relativePosition = itemPosition / outerProxyHeight
        let normalizedPosition = max(0, relativePosition)

        return 0.5 + (normalizedPosition * 0.5)
    }
    
    func calculateHue(scrollOffset: CGFloat, index: Int) -> Double { // Challenge 3
        let colorChangeFrequency: CGFloat = 500.0
        let normalizedOffset = scrollOffset / colorChangeFrequency
        let baseHue = (normalizedOffset + Double(index) * 0.1).truncatingRemainder(dividingBy: 1.0)
        return abs(baseHue)
    }
}

//struct ContentView: View {
//    var body: some View {
//        OuterView()
//            .background(.red)
//            .coordinateSpace(name: "Custom")
//    }
//}

#Preview {
    ContentView()
}
