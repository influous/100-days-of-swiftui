//
//  ContentView.swift
//  LinkMe
//
//  Created by Toto on 15/05/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingAddPersonNewView: Bool = false
    @State private var persons: [Person] = []
    
    var body: some View {
        VStack {
            NavigationStack {
                List(persons.sorted()) { person in
                    NavigationLink(destination: PersonDetailView(person: person)) {
                        HStack {
                            loadImage(for: person)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(.circle)
                                .overlay(Circle().stroke(.gray, lineWidth: 1))
                            Text(person.name)
                                .font(.headline)
                        }
                    }
                }
                .navigationTitle("LinkMe")
                .toolbar {
                    Button("Add User", systemImage: "plus") {
                        isShowingAddPersonNewView = true
                    }
                }
                .sheet(isPresented: $isShowingAddPersonNewView) {
                    AddPersonView(onSave: {
                        loadPersons()
                        isShowingAddPersonNewView = false
                    })
                }
                .onAppear(perform: loadPersons)
            }
            .padding()
        }
    }
    
    func loadPersons() {
        let url = URL.documentsDirectory.appending(path: "users.json")
        do {
            let data = try Data(contentsOf: url)
            persons = try JSONDecoder().decode([Person].self, from: data).sorted()
        } catch {
            print("Failed to load persons: \(error.localizedDescription)")
        }
    }
    
    func loadImage(for person: Person) -> Image {
        let imageURL = URL.documentsDirectory.appending(path: person.imageFilename)
        if let data = try? Data(contentsOf: imageURL), let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.crop.circle.badge.exclamationmark")
        }
    }
}

#Preview {
    ContentView()
}
