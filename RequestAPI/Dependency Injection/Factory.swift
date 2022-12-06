//
//  Factory.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation
import Swinject

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
    
    public func makeCharacterDetailViewController(model: CharacterDetailModel) -> CharacterDetailViewControllerProtocol {
        return resolver.resolveUnwrapping(CharacterDetailViewControllerProtocol.self, argument: model)
    }
    
    func makeFilmListViewController(model: FilmListModel) -> FilmListViewControllerProtocol {
        return resolver.resolveUnwrapping(FilmListViewControllerProtocol.self, argument: model)
    }
    
    func makeStarshipListViewController(model: StarshipListModel) -> StarshipListViewControllerProtocol {
        return resolver.resolveUnwrapping(StarshipListViewControllerProtocol.self, argument: model)
    }
    
}
