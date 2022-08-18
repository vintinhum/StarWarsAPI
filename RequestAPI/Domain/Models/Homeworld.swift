//
//  Homeworld.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 02/12/21.
//

import Foundation

struct Homeworld: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

extension Homeworld {
    var homeworldName: String {
        switch name {
            case "unknown":
                return name.firstCapitalized
            default:
                return name
        }
    }
}
