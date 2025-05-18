//
//  PersonDetailView.swift
//  LinkMe
//
//  Created by Toto on 17/05/2025.
//

import MapKit
import SwiftUI

struct PersonDetailView: View {
    let person: Person
    @State private var uiImage: UIImage? = nil
    
    var body: some View {
        ScrollView {
            VStack {
                Text(person.name)
                    .font(.title)
                loadImage(for: person)
                    .resizable()
                    .scaledToFill()
            }
            
            VStack {
                Text("Location")
                if let location = person.location {
                    let position = MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: location.asCLLocationCoordinate2D,
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        )
                    )
                    Map(initialPosition: position) {
                        Marker("Met here", coordinate: location.asCLLocationCoordinate2D)
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                } else {
                    Text("Location not available")
                        .foregroundColor(.secondary)
                }
            }
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
