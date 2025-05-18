//
//  Person.swift
//  LinkMe
//
//  Created by Toto on 15/05/2025.
//

import Foundation

struct Person: Identifiable, Codable, Comparable, Equatable {
    let id: UUID
    let name: String
    let imageFilename: String
    var location: Location? = nil
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
    
    static func ==(lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
}
    
