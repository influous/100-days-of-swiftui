//
//  ContentView.swift
//  Instafilter
//
//  Created by Toto on 06/05/2025.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @AppStorage("filterCount") var filterCount = 0
    @Environment(\.requestReview) var requestReview
    
    @State private var processedImage: Image?
    @State private var filterIntensity: Double = 0.5
    @State private var filterRadius: Double = 0.5
    @State private var filterScale : Double = 10.0
    @State private var selectedItem: PhotosPickerItem?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilters = false
    @State private var beginImage: CIImage?
    
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import a photo"))
                    }
                }
                .onChange(of: selectedItem, loadImage)
                .buttonStyle(.plain)
                
                Spacer()
                VStack {
                    if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                        HStack {
                            Text("Intensity")
                            Slider(value: $filterIntensity)
                                .onChange(of: filterIntensity, applyProcessing)
                            //                                .disabled(beginImage == nil || !currentFilter.inputKeys.contains(kCIInputIntensityKey))
                        }
                    }
                    if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                        HStack {
                            Text("Radius")
                            Slider(value: $filterRadius)
                                .onChange(of: filterRadius, applyProcessing)
                            //                                .disabled(beginImage == nil || !currentFilter.inputKeys.contains(kCIInputRadiusKey))
                        }
                    }
                    if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                        HStack {
                            Text("Scale")
                            Slider(value: $filterScale)
                                .onChange(of: filterScale, applyProcessing)
                            //                                .disabled(beginImage == nil || !currentFilter.inputKeys.contains(kCIInputScaleKey))
                        }
                        
                    }
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter", action: changeFilter)
                        .disabled(beginImage == nil)
                    
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter image", image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Noir") { setFilter(CIFilter.photoEffectNoir()) }
                Button("Noise Reduction") { setFilter(CIFilter.noiseReduction()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Posterize") { setFilter(CIFilter.colorPosterize()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        filterCount += 1
        
        // Request a review at 20 filter changes, then request every 10th filter change after that
        if filterCount > 20 && (filterCount - 20) % 10 == 0 {
            requestReview()
        }
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
}

#Preview {
    ContentView()
}
