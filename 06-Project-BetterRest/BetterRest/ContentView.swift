//
//  ContentView.swift
//  BetterRest
//
//  Created by Tobias on 17/01/2025.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    // Cannot use instance member 'defaultWakeTime' within property initializer; property initializers run before 'self' is available => If you try compiling that code you’ll see it fails, and the reason is that we’re accessing one property from inside another – Swift doesn’t know which order the properties will be created in, so this isn’t allowed. => change computed property defaultWakeTime to static var
    
    static var defaultWakeTime: Date {
        let components = DateComponents(hour: 7, minute: 0)
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Daily coffee intake") {
                    //                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                    Picker("Cups of coffee", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) {
                            Text("^[\($0) cup](inflect: true)")
                        }
                    }
                    .onChange(of: coffeeAmount) { newValue in
                        calculateBedtime()
                    }
                }
                
                Section("Waking up") {
                    VStack(alignment: .leading) {
                        DatePicker("Wake up at", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .onChange(of: wakeUp) { newValue in
                                calculateBedtime()
                            }
                        Stepper("Sleeping \(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                            .onChange(of: sleepAmount) { newValue in
                                calculateBedtime()
                            }
                    }
                }
                
                if showingAlert {
                    Text("Your ideal bedtime is \(alertMessage)")
                        .font(.headline)
                        .padding()
                }
            }
            .navigationTitle("BetterRest")
            //            .toolbar {
            //                Button("Calculate", action: calculateBedtime)
            //            }
            //            .alert(alertTitle, isPresented: $showingAlert) {
            //                Button("OK") { }
            //            } message: {
            //                Text(alertMessage)
            //            }
        }
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is…"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
