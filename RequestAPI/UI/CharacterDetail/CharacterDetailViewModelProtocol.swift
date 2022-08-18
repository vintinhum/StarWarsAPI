//
//  CharacterDetailViewModelProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 12/08/22.
//

import RxSwift

protocol CharacterDetailViewModelProtocol {
    
    // MARK: - PUBLIC PROPERTIES
    
    var characterDataObserver: PublishSubject<Character> { get set }
    var errorFetchCharacterData: PublishSubject<String> { get set }
    var homeworldDataObserver: PublishSubject<Homeworld> { get set }
    var errorFetchHomeworldData: PublishSubject<String> { get set }
    var viewStateObserver: BehaviorSubject<State> { get set }
    
    // MARK: - PUBLIC METHODS
    
    func fetchCharacterData()
    func fetchHomeworld(with url: String)
}
