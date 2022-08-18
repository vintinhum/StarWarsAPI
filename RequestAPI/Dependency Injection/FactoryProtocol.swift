//
//  FactoryProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import Foundation

protocol FactoryProtocol {
    func makeCharacterSelectionViewController() -> CharacterSelectionViewController
    func makeCharacterDetailViewController(model: CharacterDetailModel) -> CharacterDetailViewControllerProtocol
    func makeCharacterListViewController() -> CharacterListViewControllerProtocol
    func makeFilmListViewController(model: FilmListModel) -> FilmListViewControllerProtocol
    func makeStarshipListViewController(model: StarshipListModel) -> StarshipListViewControllerProtocol
}
