//
//  AddPersonView.swift
//  LinkMe
//
//  Created by Toto on 15/05/2025.
//

import PhotosUI
import SwiftUI

struct AddPersonView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedImage: PhotosPickerItem?
    @State private var image: Image?
    @State private var uiImage: UIImage? = nil
    @State private var name: String = ""
    @State private var isShowingNameQuery: Bool = false
    @State private var hasProvidedName: Bool = false
    @State private var persons: [Person] = []
    var onSave: (() -> Void)? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        PhotosPicker(selection: $selectedImage) {
                            if let image {
                                image
                                    .resizable()
                                    .scaledToFit()
                            } else {
                                ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo to get started"))
                            }
                        }
                        .onChange(of: selectedImage) {
                            loadImage()
                            isShowingNameQuery = true
                        }
                    }
                    if selectedImage != nil {
                        Section(header: Text("Contact Name")) {
                            TextField("What's this person's name?", text: $name)
                        }
                    }
                }
                .navigationTitle("New Person")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            savePerson()
                            dismiss()
                        }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
        }
    }
    
    func loadImage() {
        guard let selectedImage else { return }
        Task {
            if let data = try? await selectedImage.loadTransferable(type: Data.self),
               let loadedUIImage = UIImage(data: data) {
                uiImage = loadedUIImage
                image = Image(uiImage: loadedUIImage)
            }
        }
    }
    
    func savePerson() {
        // Load existing persons
        let url = URL.documentsDirectory.appending(path: "users.json")
        do {
            let data = try Data(contentsOf: url)
            persons = try JSONDecoder().decode([Person].self, from: data)
        } catch {
            print("No existing persons or failed to load: \(error.localizedDescription)")
            persons = []
        }
        
        let filename = "\(UUID().uuidString).jpg"
        let imageURL = URL.documentsDirectory.appending(path: filename)
        
        guard let imageToSave = uiImage, !name.isEmpty else { return }
        
        do {
            if let data = imageToSave.jpegData(compressionQuality: 0.8) {
                try data.write(to: imageURL, options: [.atomic, .completeFileProtection])
            }
            
            let newPerson = Person(id: UUID(), name: name, imageFilename: filename)
            persons.append(newPerson)
            
            let newPersonData = try JSONEncoder().encode(persons)
            try newPersonData.write(to: url, options: [.atomic, .completeFileProtection])
            
            onSave?()
        } catch {
            print("Error saving user or image: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AddPersonView()
}
