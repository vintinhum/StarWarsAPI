//
//  CharacterListViewControllerProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import UIKit

protocol CharacterListViewControllerProtocol: UIViewController {
    var delegate: CharacterListViewControllerDelegate? { get set }
}
