//
//  DetailView.swift
//  Bookworm
//
//  Created by Toto on 30/04/2025.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    let book: Book
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    func deleteBook() {
        modelContext.delete(book)
        dismiss()
    }
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre)
                    .resizable()
                    .scaledToFit()
                
                Text(book.genre.uppercased())
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundStyle(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                    .offset(x: -5, y: -5)
            }
            Text(book.author)
                .font(.title)
                .foregroundStyle(.primary)
            
            Text("Added \(book.date.formatted(date: .numeric, time: .omitted))")
                //.font(.subheadline)
                .foregroundStyle(.primary)
                .padding(20)
            
            Text(book.review.isEmpty ? "No review" : book.review)
                .foregroundStyle(book.review.isEmpty ? .secondary : .primary)
                .padding(20)
            
            RatingView(rating: .constant(book.rating))
                .font(.largeTitle)
                .alert("Delete book", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive, action: deleteBook)
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure?")
                }
                .toolbar {
                    Button("Delete this book", systemImage: "trash") {
                        showingDeleteAlert = true
                    }
                }
        }
        .navigationBarTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
    }

}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(title: "Test Book", author: "Test Author", genre: "Fantasy", review: "Great book", rating: 5, date: Date.now)
        
        return DetailView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
