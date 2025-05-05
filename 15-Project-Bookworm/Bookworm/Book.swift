//
//  Book.swift
//  Bookworm
//
//  Created by Toto on 28/04/2025.
//

import SwiftData
import SwiftUI

@Model
class Book {
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    var date: Date
    
    init(title: String = "Unknown", author: String = "Unknown", genre: String = "Unknown", review: String = "", rating: Int, date: Date) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
        self.date = date
    }
}


