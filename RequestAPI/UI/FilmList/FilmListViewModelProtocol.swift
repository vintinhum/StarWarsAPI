//
//  FilmListViewModelProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import Foundation
import RxSwift

protocol FilmListViewModelProtocol {
    
    // MARK: - PUBLIC PROPERTIES
    
    var filmDataObserver: PublishSubject<Character> { get set }
    var errorFetchFilmData: PublishSubject<String> { get set }
    var viewStateObserver: BehaviorSubject<State> { get set }
    
    // MARK: - PUBLIC METHODS
    
    func fetchFilmData()
    func convertFilmData(with: String) -> String
}
