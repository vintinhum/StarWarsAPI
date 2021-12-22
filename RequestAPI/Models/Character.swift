//
//  CharacterModel.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 30/11/21.
//

import Foundation

struct Character: Codable {
    let name, height, mass: String
    let birthYear, gender: String
    let homeworld: String
    let films: [String]
    let starships: [String]

    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case birthYear = "birth_year"
        case gender, homeworld, films, starships
    }
}

extension Character {
    var characterName: String {
        name
    }
    
    var characterHeight: String {
        "Height: \(height) cm"
    }
    
    var characterMass: String {
        switch mass {
        case "unknown":
            return "Mass: Unknown"
        default:
            return "Mass: \(mass) lb"
        }
    }
    
    var characterGender: String {
        switch gender {
            case "n/a":
               return "Gender: \(gender.capitalized)"
            default:
                return "Gender: \(gender.firstCapitalized)"
        }
    }
    
    var characterBirthYear: String {
        switch birthYear {
        case "unknown":
            return "Born: Unknown"
        default:
            return "Born: \(birthYear)"
        }
    }
}
