//
//  EditView.swift
//  BucketList
//
//  Created by Toto on 12/05/2025.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var editViewModel: EditViewModel
    var onSave: (Location) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $editViewModel.name)
                    TextField("Place description", text: $editViewModel.description)
                }
                Section("Nearby") {
                    switch editViewModel.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(editViewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            
                            + Text(": ") +
                            
                            Text(page.description.capitalized)
                                .italic()
                        }
                    case .failed:
                        Text("Failed. Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = editViewModel.location
                    newLocation.id = UUID()
                    newLocation.name = editViewModel.name
                    newLocation.description = editViewModel.description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await editViewModel.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _editViewModel = State(initialValue: EditViewModel(location: location))
    }
}

#Preview {
    EditView(location: .example) { _ in }
}
