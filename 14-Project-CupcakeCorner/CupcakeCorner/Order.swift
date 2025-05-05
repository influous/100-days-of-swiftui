//
//  Order.swift
//  CupcakeCorner
//
//  Created by Tobias on 13/02/2025.
//

import SwiftUI

extension String {
  var isBlank: Bool {
    return allSatisfy({ $0.isWhitespace })
  }
}

struct OrderModel: Codable {
   
    enum CodingKeys: CodingKey {
            case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
        }
    
//    enum CodingKeys: String, CodingKey {
//        case _type = "type"
//        case _quantity = "quantity"
//        case _specialRequestEnabled = "specialRequestEnabled"
//        case _extraFrosting = "extraFrosting"
//        case _addSprinkles = "addSprinkles"
//        case _name = "name"
//        case _city = "city"
//        case _streetAddress = "streetAddress"
//        case _zip = "zip"
//    }
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        if name.isBlank || streetAddress.isBlank || city.isBlank || zip.isBlank {
            return false
        }
        
        return true
    }
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // complicated cakes cost more
        cost += Decimal(type) / 2
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    var name = UserDefaults.standard.string(forKey: "name") ?? ""
    var streetAddress = ""
    var city = ""
    var zip = ""
}

class Order: ObservableObject {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    @Published var data = OrderModel()
}
