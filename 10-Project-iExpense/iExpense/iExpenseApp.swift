//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Tobias on 26/01/2025.
//

import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expenses.self)
    }
}
