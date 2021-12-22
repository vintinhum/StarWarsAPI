//
//  Networking.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation
import Alamofire

class URLSessionNetworking: NetworkingProtocol {
    
    // MARK: - PUBLIC FUNCTIONS
    
    func fetchCaracter(requestType: RequestType, characterNumber: Int, completion: @escaping (Result<Character, ServiceError>) -> Void) {
        guard let url = URL(string: "https://swapi.dev/api/people" + "/\(characterNumber)") else { return }
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
    
    func fetchHomeworld(requestType: RequestType, url: String, completion: @escaping (Result<Homeworld, ServiceError>) -> Void) {
        guard let url = URL(string: url) else { return }
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
}

class AlamofireNetworking: NetworkingProtocol {
    
    // MARK: - PUBLIC FUNCTIONS

    func fetchCaracter(requestType: RequestType, characterNumber: Int, completion: @escaping (Result<Character, ServiceError>) -> Void) {
        guard let url = URL(string: "https://swapi.dev/api/people" + "/\(characterNumber)") else { return }
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
    
    func fetchHomeworld(requestType: RequestType, url: String, completion: @escaping (Result<Homeworld, ServiceError>) -> Void) {
        AF.request(url).validate().responseJSON { data in
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
}
