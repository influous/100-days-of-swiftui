//
//  ContentView.swift
//  iExpense
//
//  Created by Tobias on 26/01/2025.
//

import SwiftData
import SwiftUI

enum SortOption: String, CaseIterable, Identifiable {
    case name = "Name"
    case amount = "Amount"
    
    var id: Self { self }
    
    var descriptor: [SortDescriptor<Expenses>] {
        switch self {
        case .name: [SortDescriptor(\.name)]
        case .amount: [SortDescriptor(\.amount, order: .reverse)]
        }
    }
}

enum CategoryFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case personal = "Personal"
    case business = "Business"
    
    var id: Self { self }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var sortOption: SortOption = .name
    @State private var categoryFilter: CategoryFilter = .all
    
    var body: some View {
        NavigationStack {
            ExpensesView(sortDescriptor: sortOption.descriptor, categoryFilter: categoryFilter)
                .navigationTitle("iExpense")
                .toolbar {
                    Group {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink {
                                AddView()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu("Filter") {
                                Picker("Category", selection: $categoryFilter) {
                                    ForEach(CategoryFilter.allCases) { filter in
                                        Text(filter.rawValue).tag(filter)
                                    }
                                }
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                                Picker("Sort by", selection: $sortOption) {
                                    ForEach(SortOption.allCases) { option in
                                        Text(option.rawValue).tag(option)
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
