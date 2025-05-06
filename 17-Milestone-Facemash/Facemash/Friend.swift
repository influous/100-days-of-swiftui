//
//  Friend.swift
//  Facemash
//
//  Created by Toto on 05/05/2025.
//

import SwiftData
import SwiftUI

@Model
class Friend: Codable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    var id: String
    var name: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}
