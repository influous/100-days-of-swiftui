//
//  DetailView.swift
//  Facemash
//
//  Created by Toto on 05/05/2025.
//

import SwiftData
import SwiftUI

struct DetailView: View {
    let user: User
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading) {
                    Text(user.name)
                        .font(.largeTitle.bold())
                    
                    HStack {
                        Text(user.isActive ? "Active" : "Inactive")
                            .foregroundColor(user.isActive ? .green : .red)
                        
                        Spacer()
                        
                        Text("Company: \(user.company)")
                            .font(.subheadline)
                    }
                    .font(.subheadline)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contact")
                        .font(.headline)
                    Text(user.email)
                    Text(user.address)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("About")
                        .font(.headline)
                    Text("Joined: \(user.registered.formatted(date: .abbreviated, time: .omitted))")
                    Text("Age: \(user.age)")
                    Text(user.about)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Friends (\(user.friends.count))")
                        .font(.headline)
                    
                    ForEach(user.friends, id: \.id) { friend in
                        Text(friend.name)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tags (\(user.tags.count))")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(user.tags, id: \.self) { tag in
                                Text(tag)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(.capsule)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("User Profile")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}
