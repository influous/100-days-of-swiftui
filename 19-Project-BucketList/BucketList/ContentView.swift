//
//  ContentView.swift
//  BucketList
//
//  Created by Toto on 10/05/2025.
//

import MapKit
import SwiftUI

extension FileManager { // Day 68 challenge
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct ContentView: View {
    private(set) var locations = [Location]()
    @State private var viewModel = ViewModel()
    @State private var mapType: MapStyle = .standard
    @State private var showingMapOptions = false
    
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    var body: some View {
        if viewModel.isUnlocked {
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.red)
                                .background(.white)
                                .frame(width: 44, height: 44)
                                .clipShape(.circle)
                                .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded { _ in viewModel.selectedPlace = location }) //onLongPressGesture will not work here
                        }
                    }
                }
                .mapStyle(mapType)
                .overlay(
                    Button(action: {
                        showingMapOptions = true
                    }) {
                        Image(systemName: "map")
                            .padding(10)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding([.top, .trailing], 16),
                    alignment: .topTrailing
                )
                .actionSheet(isPresented: $showingMapOptions) {
                    ActionSheet(
                        title: Text("Map Type"),
                        buttons: [
                            .default(Text("Standard")) { mapType = .standard },
                            .default(Text("Hybrid")) { mapType = .hybrid },
                            .default(Text("Satellite")) { mapType = .imagery },
                            .cancel()
                        ]
                    )
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        viewModel.addLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) {
                        viewModel.updateLocation($0)
                    }
                }
            }
            .padding()
        } else {
            Button("Authenticate", action: viewModel.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(.capsule)
                .alert("Authentication error", isPresented: $viewModel.showingAuthenticationAlert) { } message: {
                    Text(viewModel.errorMessage)
                }
        }
    }
    
}

#Preview {
    ContentView()
}
