//
//  CharacterListViewControllerDelegate.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import Foundation

protocol CharacterListViewControllerDelegate: AnyObject {
    func goToStarshipList(model: StarshipListModel)
    func goToFilmList(model: FilmListModel)
}
