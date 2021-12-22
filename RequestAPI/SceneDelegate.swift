//
//  SceneDelegate.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 29/11/21.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppMainCoordinator?
    var container: Container?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
                
        let dependencyProvider = DependencyProvider()
        container = dependencyProvider.container
        
        let navigationController = UINavigationController()
        coordinator = container?.resolveUnwrapping(AppMainCoordinator.self, argument: navigationController)
        coordinator?.start()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
