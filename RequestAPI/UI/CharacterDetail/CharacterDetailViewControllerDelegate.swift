//
//  CharacterDetailViewControllerDelegate.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 12/08/22.
//

import Foundation

protocol CharacterDetailViewControllerDelegate: AnyObject {
    func showStarshipList(model: StarshipListModel)
    func showFilmList(model: FilmListModel)
}
