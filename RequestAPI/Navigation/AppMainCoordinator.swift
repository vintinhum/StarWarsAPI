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
    
    func presentCharacterDetail(requestType: RequestType, characterNumber: Int) {
        let viewController = factory.makeCharacterDetailViewController(requestType: requestType, characterNumber: characterNumber)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentFilmList(requestType: RequestType, characterNumber: Int) {
        let viewController = factory.makeFilmListViewController(requestType: requestType, characterNumber: characterNumber)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentStarshipList(requestType: RequestType, characterNumber: Int) {
        let viewController = factory.makeStarshipListViewController(requestType: requestType, characterNumber: characterNumber)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - CHARACTER SELECTION VIEWCONTROLLER DELEGATE

extension AppMainCoordinator: CharacterSelectionViewControllerDelegate {
    func showCharacterDetail(requestType: RequestType, characterNumber: Int) {
        presentCharacterDetail(requestType: requestType, characterNumber: characterNumber)
    }
}

// MARK: - CHARACTER DETAIL VIEWCONTROLLER DELEGATE

extension AppMainCoordinator: CharacterDetailCollectionViewControllerDelegate {
    func showStarshipList(requestType: RequestType, characterNumber: Int) {
        presentStarshipList(requestType: requestType, characterNumber: characterNumber)
    }
    
    func showFilmList(requestType: RequestType, characterNumber: Int) {
        presentFilmList(requestType: requestType, characterNumber: characterNumber)
    }
}
