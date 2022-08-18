//
//  Service.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation
import Alamofire

class URLSessionService: ServiceProtocol {
    
    // MARK: - PUBLIC FUNCTIONS
    
    func fetchCaracter(request: RequestProtocol,
                       completion: @escaping (Result<Character, ServiceError>) -> Void) {
        guard let url = URL(string: request.path) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(Character.self, from: data)
                    completion(.success(response))
                    print(response)
                } catch let error {
                    print("Error during JSON serialization: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func fetchHomeworld(request: RequestProtocol,
                        completion: @escaping (Result<Homeworld, ServiceError>) -> Void) {
        guard let url = URL(string: request.path) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(Homeworld.self, from: data)
                    completion(.success(response))
                    print(response)
                } catch let error {
                    print("Error during JSON serialization: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func fetchCharacterList(request: RequestProtocol,
                            completion: @escaping (Result<CharacterListResponse, ServiceError>) -> Void) {
        guard let url = URL(string: request.path) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(CharacterListResponse.self, from: data)
                    completion(.success(response))
                    print(response)
                } catch let error {
                    print("Error during JSON serialization: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

class AlamofireService: ServiceProtocol {
    
    // MARK: - PUBLIC FUNCTIONS

    func fetchCaracter(request: RequestProtocol,
                       completion: @escaping (Result<Character, ServiceError>) -> Void) {
        guard let url = URL(string: request.path) else { return }
        AF.request(url).validate().responseJSON { data in
            do {
                if let data = data.data {
                    let response = try JSONDecoder().decode(Character.self, from: data)
                    completion(.success(response))
                }
            } catch {
                print("Error during JSON serialization: \(error)")
            }
        }
    }
    
    func fetchHomeworld(request: RequestProtocol,
                        completion: @escaping (Result<Homeworld, ServiceError>) -> Void) {
        AF.request(request.path).validate().responseJSON { data in
            do {
                if let data = data.data {
                    let response = try JSONDecoder().decode(Homeworld.self, from: data)
                    completion(.success(response))
                }
            } catch {
                print("Error during JSON serialization: \(error)")
            }
        }
    }
    
    func fetchCharacterList(request: RequestProtocol,
                            completion: @escaping (Result<CharacterListResponse, ServiceError>) -> Void) {
        guard let url = URL(string: request.path) else { return }
        AF.request(url).validate().responseJSON { data in
            do {
                if let data = data.data {
                    let response = try JSONDecoder().decode(CharacterListResponse.self, from: data)
                    completion(.success(response))
                }
            } catch {
                print("Error during JSON serialization: \(error)")
            }
        }
    }
}
