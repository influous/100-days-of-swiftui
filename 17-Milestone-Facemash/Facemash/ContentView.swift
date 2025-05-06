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
//                    testData()
                }
            }
            .navigationTitle("Facemash")
        }
    }
    
    func testData() {
        let jsonData = """
            {
                "id": "50a48fa3-2c0f-4397-ac50-64da464f9954",
                "isActive": false,
                "name": "Alford Rodriguez",
                "age": 21,
                "company": "Imkan",
                "email": "alfordrodriguez@imkan.com",
                "address": "907 Nelson Street, Cotopaxi, South Dakota, 5913",
                "about": "Occaecat consequat...",
                "registered": "2015-11-10T01:47:18-00:00",
                "tags": ["cillum", "consequat"],
                "friends": [{"id": "91b5be3d-9a19-4ac2-b2ce-89cc41884ed0", "name": "Hawkins Patel"}]
            }
            """.data(using: .utf8)!
        
        do {
            let user = try JSONDecoder().decode(User.self, from: jsonData)
            print("Successfully decoded user: \(user.name)")
        } catch {
            print("Decoding error: \(error)")
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
