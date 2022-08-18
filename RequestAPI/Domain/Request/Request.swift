//
//  Request.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import Foundation

enum Request: RequestProtocol {
    case character(request: CharacterRequestModel)
    case homeworld(request: HomeworldRequestModel)
    case characterList
    case characterListWithURL(request: CharacterListRequestModel)
    
    var path: String {
        switch self {
        case .character(let request):
            return "https://swapi.dev/api/people/\(request.characterNumber)"
        case .homeworld(let request):
            return request.url
        case .characterList:
            return "https://swapi.dev/api/people"
        case .characterListWithURL(let request):
            return request.url
        }
    }
}
