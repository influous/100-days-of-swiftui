//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Tobias on 13/02/2025.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
//    @State var orderModel: OrderModel

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.data.name)
                TextField("Street Address", text: $order.data.streetAddress)
                TextField("City", text: $order.data.city)
                TextField("Zip", text: $order.data.zip)
            }

            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                }
            }
            .disabled(order.data.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear(perform: {
                    //save to user defaults
            if let data = try? JSONEncoder().encode(order.data) {
                        UserDefaults.standard.set(data, forKey: "orderKey")
                    }
                })
                .onAppear(perform: {
                    // load from user defaults
                    if let object = UserDefaults.standard.value(forKey: "orderKey") as? Data {
                        if let loadedOrder = try? JSONDecoder().decode(OrderModel.self, from: object) {
                            self.order.data.name = loadedOrder.name
                            self.order.data.streetAddress = loadedOrder.streetAddress
                            self.order.data.city = loadedOrder.city
                            self.order.data.zip = loadedOrder.zip
                            print("object loaded")
                        }
                    }
                })
    }
}

#Preview {
    AddressView(order: Order())
}
