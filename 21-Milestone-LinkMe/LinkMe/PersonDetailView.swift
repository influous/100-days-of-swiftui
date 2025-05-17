//
//  PersonDetailView.swift
//  LinkMe
//
//  Created by Toto on 17/05/2025.
//

import SwiftUI

struct PersonDetailView: View {
    let person: Person
    @State private var uiImage: UIImage? = nil
    
    var body: some View {
        VStack {
            Text(person.name)
                .font(.headline)
            loadImage(for: person)
                .resizable()
                .scaledToFill()
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
    PersonDetailView(person: .init(id: UUID(), name: "Toto", imageFilename: "toto.jpg"))
}
