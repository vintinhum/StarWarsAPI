//
//  NetworkingProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation

protocol ServiceProtocol {
    func fetchCaracter(request: RequestProtocol,
                       completion: @escaping (Result<Character, ServiceError>) -> Void)
    func fetchHomeworld(request: RequestProtocol,
                        completion: @escaping (Result<Homeworld, ServiceError>) -> Void)
    func fetchCharacterList(request: RequestProtocol,
                            completion: @escaping (Result<CharacterListResponse, ServiceError>) -> Void)
}
