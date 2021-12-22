//
//  Coordinator.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 29/11/21.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func start()
}
