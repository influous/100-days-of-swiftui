//
//  Card.swift
//  Flashzilla
//
//  Created by Toto on 25/05/2025.
//

import Foundation

struct Card: Codable, Identifiable {
    var id = UUID()
    var prompt: String
    var answer: String
    static let example = Card(prompt: "What is Swift?", answer: "A high-level programming language.")
}
