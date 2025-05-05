//
//  ContentView.swift
//  WeConvert
//
//  Created by Tobias on 10/01/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var inputTemp: Double = 0.0
    @State private var inputTempUnit: UnitTemperature = .celsius
    @State private var outputTempUnit: UnitTemperature = .fahrenheit
    @FocusState private var inputTempIsFocused: Bool
    
    var outputTemp: Double {
        let inputMeasurement = Measurement(value: inputTemp, unit: inputTempUnit)
        return inputMeasurement.converted(to: outputTempUnit).value
    }
    
    let units: [UnitTemperature] = [.fahrenheit, .celsius, .kelvin]
    
    var body: some View {
        NavigationView {
            Form {
                Section("Unit 1") {
                    Picker("Unit to convert from", selection: $inputTempUnit) {
                        ForEach(units, id: \.self) {
                            Text("\($0.symbol)")
                        }
                    }
                }
                Section("Enter current temperature") {
                    TextField("Temp", value: $inputTemp, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputTempIsFocused)
                }
                Section("Unit 2") {
                    Picker("Unit to convert to", selection: $outputTempUnit) {
                        ForEach(units, id: \.self) {
                            Text("\($0.symbol)")
                        }
                    }
                }
                Section("Result") {
                    Text(outputTemp.formatted())
                }
            }
            .navigationTitle("WeConvert")
            .toolbar {
                if inputTempIsFocused {
                    Button("Done") {
                        inputTempIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

