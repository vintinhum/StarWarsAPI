//
//  CharacterListResponse.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import Foundation

struct CharacterListResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Character]
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
    }
}
