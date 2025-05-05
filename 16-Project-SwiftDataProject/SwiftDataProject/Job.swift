//
//  Job.swift
//  SwiftDataProject
//
//  Created by Toto on 02/05/2025.
//

import SwiftData
import SwiftUI

@Model
class Job {
    var name: String = "None"
    var priority: Int = 1
    var owner: User?

    init(name: String, priority: Int, owner: User? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
}
