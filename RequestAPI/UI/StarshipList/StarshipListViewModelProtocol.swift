//
//  StarshipListViewModelProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import RxSwift

protocol StarshipListViewModelProtocol {
    
    // MARK: - PUBLIC PROPERTIES
    
    var starshipDataObserver: PublishSubject<Character> { get set }
    var errorFetchStarshipData: PublishSubject<String> { get set }
    var viewStateObserver: BehaviorSubject<State> { get set }
    
    // MARK: - PUBLIC METHODS
    
    func fetchStarshipData()
}
