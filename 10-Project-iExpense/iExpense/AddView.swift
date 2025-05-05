//
//  AddView.swift
//  iExpense
//
//  Created by Tobias on 28/01/2025.
//

import SwiftData
import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack{
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let item = Expenses(name: name, type: type, amount: amount)
                        modelContext.insert(item)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add new expense")
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    AddView()
}
