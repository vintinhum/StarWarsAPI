//
//  AppMainCoordinator.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 29/11/21.
//

import UIKit

class AppMainCoordinator: Coordinator {

    // MARK: - PROPERTIES
    
    var navigationController: UINavigationController?
    let factory: Factory
    
    // MARK: - INITIALIZERS
    
    init(navigationController: UINavigationController, factory: Factory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func start() {
        let viewController = factory.makeCharacterSelectionViewController()
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func presentCharacterDetail(model: CharacterDetailModel) {
        let viewController = factory.makeCharacterDetailViewController(model: model)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentFilmList(model: FilmListModel) {
        let viewController = factory.makeFilmListViewController(model: model)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentStarshipList(model: StarshipListModel) {
        let viewController = factory.makeStarshipListViewController(model: model)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - CharacterSelectionViewControllerDelegate

extension AppMainCoordinator: CharacterSelectionViewControllerDelegate {
    func showCharacterDetail(model: CharacterDetailModel) {
        presentCharacterDetail(model: model)
    }
}

// MARK: - CharacterDetailViewControllerDelegate

extension AppMainCoordinator: CharacterDetailViewControllerDelegate {
    func showStarshipList(model: StarshipListModel) {
        presentStarshipList(model: model)
    }
    
    func showFilmList(model: FilmListModel) {
        presentFilmList(model: model)
    }
}
