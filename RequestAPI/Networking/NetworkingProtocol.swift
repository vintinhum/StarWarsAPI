//
//  NetworkingProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation

protocol NetworkingProtocol {
    typealias CharacterResponse = (Character) -> Void
    typealias HomeworldResponse = (Homeworld) -> Void
    
    func fetchCaracter(requestType: RequestType, characterNumber: Int, completion: @escaping (Result<Character, ServiceError>) -> Void)
    func fetchHomeworld(requestType: RequestType, url: String, completion: @escaping (Result<Homeworld, ServiceError>) -> Void)
}
