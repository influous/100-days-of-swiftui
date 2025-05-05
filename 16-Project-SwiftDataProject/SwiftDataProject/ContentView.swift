//
//  ContentView.swift
//  SwiftDataProject
//
//  Created by Toto on 01/05/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
//    @Query(sort: \User.name) var users: [User]
    @Query(filter: #Predicate<User> { user in
        if user.name.localizedStandardContains("R") {
            if user.city == "London" {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }, sort: \User.name) var users: [User]
    @State private var path = [User]()
    @State private var showingUpcomingOnly = false
    
    @State private var sortOrder = [
        SortDescriptor(\User.name),
        SortDescriptor(\User.joinDate),
    ]
    
    func addSample() {
        let user1 = User(name: "Piper Chapman", city: "New York", joinDate: .now)
        let job1 = Job(name: "Organize sock drawer", priority: 3)
        let job2 = Job(name: "Make plans with Alex", priority: 4)

        modelContext.insert(user1)

        user1.jobs?.append(job1)
        user1.jobs?.append(job2)
    }
    
    var body: some View {
        NavigationStack {
            UsersView(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
            .navigationTitle("Users")
            .toolbar {
                Button(showingUpcomingOnly ? "Show Everyone" : "Show Upcoming") {
                    showingUpcomingOnly.toggle()
                }
                Button("Add jobs") {
                    addSample()
                }
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort by Name")
                            .tag([
                                SortDescriptor(\User.name),
                                SortDescriptor(\User.joinDate)
                            ])
                        
                        Text("Sort by Join Date")
                            .tag([
                                SortDescriptor(\User.joinDate),
                                SortDescriptor(\User.name)
                            ])
                    }
                }

//                Button("Add Samples", systemImage: "plus") {
//                    try? modelContext.delete(model: User.self)
//                    let first = User(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
//                    let second = User(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
//                    let third = User(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
//                    let fourth = User(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))
//                    
//                    modelContext.insert(first)
//                    modelContext.insert(second)
//                    modelContext.insert(third)
//                    modelContext.insert(fourth)
//                }
            }
        }
//        VStack {
//            NavigationStack(path: $path) {
//                List(users) { user in
//                    NavigationLink(value: user) {
//                        Text(user.name)
//                    }
//                }
//                .navigationTitle("Users")
//                .navigationDestination(for: User.self) { user in
//                    EditUserView(user: user)
//                }
//                .toolbar {
//                    Button("Add User", systemImage: "plus") {
//                        let user = User(name: "", city: "", joinDate: .now)
//                        modelContext.insert(user)
//                        path = [user]
//                    }
//                }
//            }
//        }
        .padding()
    }
}

#Preview {
    ContentView()
}
