//
//  UsersView.swift
//  SwiftDataProject
//
//  Created by Toto on 02/05/2025.
//

import SwiftData
import SwiftUI

struct UsersView: View {
    @Query var users: [User]
    @Environment(\.modelContext) var modelContext
    
    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
        _users = Query(filter: #Predicate<User> { user in
            user.joinDate >= minimumJoinDate
        }, sort: sortOrder)
    }
    
    var body: some View {
        List(users) { user in
            Text(user.name)
        }
        
        List(users) { user in
            HStack {
                Text(user.name)

                Spacer()

                Text(String(user.unwrappedJobs.count))
                    .fontWeight(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
    }
}

#Preview {
    UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}
