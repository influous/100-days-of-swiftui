//
//  ExpensesView.swift
//  iExpense
//
//  Created by Toto on 03/05/2025.
//

import SwiftData
import SwiftUI

struct ExpensesView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expenses]
    @Query var personalItems: [Expenses]
    @Query var businessItems: [Expenses]
    
    init(sortDescriptor: [SortDescriptor<Expenses>], categoryFilter: CategoryFilter) {
        let personalPredicate = #Predicate<Expenses> { $0.type == "Personal" }
        let businessPredicate = #Predicate<Expenses> { $0.type == "Business" }
        
        switch categoryFilter {
        case .all:
            _personalItems = Query(filter: personalPredicate, sort: sortDescriptor)
            _businessItems = Query(filter: businessPredicate, sort: sortDescriptor)
        case .personal:
            _personalItems = Query(filter: personalPredicate, sort: sortDescriptor)
            _businessItems = Query(filter: #Predicate { _ in false }) // Empty query
        case .business:
            _personalItems = Query(filter: #Predicate { _ in false }) // Empty query
            _businessItems = Query(filter: businessPredicate, sort: sortDescriptor)
        }
    }
    
    var body: some View {
        List {
            if !personalItems.isEmpty {
                Section("Personal") {
                    ForEach(personalItems) { item in
                        expenseRow(item)
                    }
                    .onDelete(perform: removeItems)
                }
            }
            
            if !businessItems.isEmpty {
                Section("Business") {
                    ForEach(businessItems) { item in
                        expenseRow(item)
                    }
                    .onDelete(perform: removeItems)
                }
            }
        }
    }
    
    private func expenseRow(_ item: Expenses) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            
            Spacer()
            
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .foregroundColor(item.amount > 100 ? .red : (item.amount < 10 ? .green : .indigo))
        }
        .accessibilityElement()
        .accessibilityLabel(Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD")
            ))
        .accessibilityHint(item.type)
    }
    
    private func removeItems(at offsets: IndexSet) {
        for offset in offsets {
            let item = expenses[offset]
            modelContext.delete(item)
        }
    }
}

#Preview {
    ExpensesView(
        sortDescriptor: [SortDescriptor(\.name)],
        categoryFilter: .all
    )
}
