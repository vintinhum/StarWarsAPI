//
//  Factory.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation
import Swinject

protocol FactoryProtocol {
    func makeCharacterSelectionViewController() -> CharacterSelectionViewController
    func makeCharacterDetailViewController(requestType: RequestType, characterNumber: Int) -> CharacterDetailCollectionViewController
    func makeFilmListViewController(requestType: RequestType, characterNumber: Int) -> FilmListTableViewController
    func makeStarshipListViewController(requestType: RequestType, characterNumber: Int) -> StarshipListTableViewController
}

class Factory: FactoryProtocol {
    
    // MARK: - PROPERTIES
    
    let resolver: Resolver
    
    // MARK: - INITIALIZERS
    
    public init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    public func makeCharacterSelectionViewController() -> CharacterSelectionViewController {
        return resolver.resolveUnwrapping(CharacterSelectionViewController.self)
    }
    
    public func makeCharacterDetailViewController(requestType: RequestType, characterNumber: Int) -> CharacterDetailCollectionViewController {
        return resolver.resolveUnwrapping(CharacterDetailCollectionViewController.self, arguments: requestType, characterNumber)
    }
    
    func makeFilmListViewController(requestType: RequestType, characterNumber: Int) -> FilmListTableViewController {
        return resolver.resolveUnwrapping(FilmListTableViewController.self, arguments: requestType, characterNumber)
    }
    
    func makeStarshipListViewController(requestType: RequestType, characterNumber: Int) -> StarshipListTableViewController {
        return resolver.resolveUnwrapping(StarshipListTableViewController.self, arguments: requestType, characterNumber)
    }
    
}
