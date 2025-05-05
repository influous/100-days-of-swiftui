//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Tobias on 12/02/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.data.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }

                    Stepper("Number of cakes: \(order.data.quantity)", value: $order.data.quantity, in: 3...20)
                }
                Section {
                    Toggle("Any special requests?", isOn: $order.data.specialRequestEnabled)

                    if order.data.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.data.extraFrosting)

                        Toggle("Add extra sprinkles", isOn: $order.data.addSprinkles)
                    }
                }
                Section {
                    NavigationLink("Delivery details") {
                        AddressView(order: order)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview {
    ContentView()
}
