//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Toto on 01/05/2025.
//

import SwiftData
import SwiftUI

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self) 
    }
}
