//
//  CharacterListViewModelProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import RxSwift

protocol CharacterListViewModelProtocol {
    
    // MARK: - PUBLIC PROPERTIES
    
    var viewStateObserver: BehaviorSubject<State> { get set }
    var characterListDataObserver: PublishSubject<[Character]> { get set }
    var homeworldListDataObserver: PublishSubject<[Homeworld]> { get set }
    var characterListErrorObserver: PublishSubject<String> { get set }
    
    // MARK: - PUBLIC METHODS
    
    func retrieveCharacters()
    func retrieveHomeworlds(for characters: [Character])
}
