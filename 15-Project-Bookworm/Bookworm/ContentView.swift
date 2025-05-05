//
//  ContentView.swift
//  Bookworm
//
//  Created by Toto on 28/04/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    // @Query var books: [Book]
    // @Query(sort: [SortDescriptor(\Book.title, order: .reverse)]) var books: [Book]
    @Query(sort: [
        SortDescriptor(\Book.title),
        SortDescriptor(\Book.author)
    ]) var books: [Book]
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            
            modelContext.delete(book)
        }
    }

    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationStack {
            //           Text("Count: \(books.count)")
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)

                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                    .foregroundStyle(book.rating == 1 ? .red : .primary)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationDestination(for: Book.self) { book in DetailView(book: book)
            }
               .navigationTitle("Bookworm")
               .toolbar {
                   ToolbarItem(placement: .topBarTrailing) {
                       Button("Add Book", systemImage: "plus") {
                           showingAddScreen.toggle()
                       }
                   }
                   ToolbarItem(placement: .topBarLeading) {
                       EditButton()
                   }
               }
               .sheet(isPresented: $showingAddScreen) {
                   AddBookView()
               }
       }
    }
}

#Preview {
    ContentView()
}
