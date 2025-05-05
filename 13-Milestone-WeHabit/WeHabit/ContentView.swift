//
//  ContentView.swift
//  WeHabit
//
//  Created by Tobias on 11/02/2025.
//

import SwiftUI

struct ActivityItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let progressAmount: Double
}

@Observable
class Activities {
    var items = [ActivityItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ActivityItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var activities = Activities()
    
    let types = ["Daily", "Weekly"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(types, id: \.self) { category in
                    Text(category)
                    Section(header: Text(category)) {
                        ForEach(activities.items.filter { $0.type == category }) { item in
                            HStack {
                                VStack {
                                    Text(item.name)
                                        .font(.headline)
                                }
                                
                                Spacer()
                                Text(item.progressAmount)
                            }
                        }
                        .onDelete(perform: removeItems)
                    }
                }
            }
            .toolbar {
                NavigationLink(destination: "Test") {
                    Image(Image(systemName: "plus"))
                }
            }
            .navigationTitle("WeHabit")
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        activities.items.remove(atOffsets: offsets)
    }
}

//#Preview {
//    ContentView()
//}
