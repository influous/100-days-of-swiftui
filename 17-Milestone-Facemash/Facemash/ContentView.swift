//
//  ContentView.swift
//  Facemash
//
//  Created by Toto on 05/05/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var users = [User]()
    
    var body: some View {
        NavigationStack {
            List(users, id: \.id) { user in
                
                NavigationLink {
                    DetailView(user: user)
                } label: {
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.headline)
                        Text(user.activeStatus)
                            .font(.subheadline)
                            .foregroundColor(user.isActive ? .green : .red)
                    }
                }
            }
            .task {
                if users.isEmpty {
                    await loadData()
                }
            }
            .navigationTitle("Facemash")
        }
        
    }
    
    func loadData() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? decoder.decode([User].self, from: data) {
                users = decodedResponse
                print("Successfully loaded \(users.count) users")
                
            }
        } catch {
            print("Checkout failed: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
