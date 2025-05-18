//
//  Location.swift
//  LinkMe
//
//  Created by Toto on 18/05/2025.
//

import MapKit

struct Location: Codable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    init(from coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    var asCLLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
