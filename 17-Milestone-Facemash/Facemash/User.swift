//
//  User.swift
//  Facemash
//
//  Created by Toto on 05/05/2025.
//

import SwiftUI

struct User: Codable, Hashable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [Friend]
    
    var activeStatus: String {
        isActive ? "Active" : "Inactive"
    }
}
