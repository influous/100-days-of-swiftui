//
//  EditView.swift
//  HotProspects
//
//  Created by Toto on 24/05/2025.
//

import SwiftUI

struct EditView: View {
    @Bindable var prospect: Prospect
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $prospect.name)
                TextField("Email address", text: $prospect.email)
            }
            Section {
                Button {
                    prospect.isContacted.toggle()
                } label: {
                    Label(
                        prospect.isContacted ? "Mark as not contacted" : "Mark as contacted",
                        systemImage: prospect.isContacted ? "checkmark.circle.fill" : "circle"
                    )
                }
            }
            
        }
        .navigationTitle("Edit contact")
    }
}
