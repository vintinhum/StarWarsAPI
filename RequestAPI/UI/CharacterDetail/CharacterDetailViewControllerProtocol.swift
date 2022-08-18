//
//  CharacterDetailViewControllerProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 12/08/22.
//

import UIKit

protocol CharacterDetailViewControllerProtocol: UIViewController {
    var delegate: CharacterDetailViewControllerDelegate? { get set }
}
