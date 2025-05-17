//
//  Person.swift
//  LinkMe
//
//  Created by Toto on 15/05/2025.
//

import Foundation

struct Person: Identifiable, Codable, Comparable {
    let id: UUID
    let name: String
    let imageFilename: String
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
}
