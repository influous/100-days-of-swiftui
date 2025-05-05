//
//  Expenses.swift
//  iExpense
//
//  Created by Toto on 04/05/2025.
//

import SwiftData
import SwiftUI

@Model
class Expenses {
    var name: String = "Expense"
    var type: String = "Personal"
    var amount: Double = 0.0
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}
