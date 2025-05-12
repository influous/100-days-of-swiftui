//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Toto on 12/05/2025.
//

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    @Observable
    class ViewModel {
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        private(set) var locations: [Location]
        var errorMessage: String = ""
        var isUnlocked = false
        var selectedPlace: Location?
        var showingAuthenticationAlert = false

        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func updateLocation(_ location: Location) {
            guard let selectedPlace else { return }
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate to unlock your maps."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    // authentication has now completed
                    if success {
                        self.isUnlocked = true
                    } else {
                        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                            if success {
                                self.isUnlocked = true
                            } else {
                                if let error = authenticationError {
                                    self.showingAuthenticationAlert = true
                                    self.errorMessage = error.localizedDescription
                                }
                            }
                        }
                    }
                }
            } else {
                // no biometrics
                let reason = "Please enter your passcode to unlock your maps."
                
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        if let error = authenticationError {
                            self.showingAuthenticationAlert = true
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }
            }
            self.showingAuthenticationAlert = false
        }
    }
}




