//
//  CharacterDetailViewModel.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 01/12/21.
//

import UIKit
import Alamofire
import RxSwift

protocol CharacterDetailViewModelProtocol: AnyObject {
    typealias CharacterResponse = (Character) -> Void
    typealias HomeworldResponse = (Homeworld) -> Void
    func fetchCharacterData(requestType: RequestType, for characterNumber: Int, completion: @escaping CharacterResponse)
    func fetchHomeworld(requestType: RequestType, url: String, completion: @escaping HomeworldResponse)
}

public enum State {
    case idle
    case loading
}

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {

    // MARK: - PRIVATE PROPERTIES
    
    private let disposeBag = DisposeBag()
    private let fetchCharacterWithURLUseCase: FetchCharacterWithURLSessionUseCaseProtocol
    private let fetchCharacterWithAlamofireUseCase: FetchCharacterWithAlamofireUseCaseProtocol
    private let fetchHomeworldWithURLSessionUseCase: FetchHomeworldWithURLSessionUseCaseProtocol
    private let fetchHomeworldWithAlamofireUseCase: FetchHomeworldWithAlamofireUseCaseProtocol
    
    // MARK: - OBSERVERS
    
    let characterDataObserver = PublishSubject<Character>()
    let errorFetchCharacterData = PublishSubject<String>()
    let homeworldDataObserver = PublishSubject<Homeworld>()
    let errorFetchHomeworldData = PublishSubject<String>()
    let viewStateObserver = PublishSubject<State>()
    
    // MARK: - INITIALIZERS
    
    init(fetchCharacterWithURLUseCase: FetchCharacterWithURLSessionUseCaseProtocol,
         fetchCharacterWithAlamofireUseCase: FetchCharacterWithAlamofireUseCaseProtocol,
         fetchHomeworldWithURLSessionUseCase: FetchHomeworldWithURLSessionUseCaseProtocol,
         fetchHomeworldWithAlamofireUseCase: FetchHomeworldWithAlamofireUseCaseProtocol) {
        self.fetchCharacterWithURLUseCase = fetchCharacterWithURLUseCase
        self.fetchCharacterWithAlamofireUseCase = fetchCharacterWithAlamofireUseCase
        self.fetchHomeworldWithURLSessionUseCase = fetchHomeworldWithURLSessionUseCase
        self.fetchHomeworldWithAlamofireUseCase = fetchHomeworldWithAlamofireUseCase
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func fetchCharacterData(requestType: RequestType, for characterNumber: Int, completion: @escaping CharacterResponse) {
        switch requestType {
            case .urlsession:
                self.fetchCharacterWithURLUseCase
                    .execute(requestType: requestType,
                             characterNumber: characterNumber,
                             completion: completion)
                    .subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                        self?.handleCharacterData(usecase)
                    }
            case .alamofire:
                self.fetchCharacterWithAlamofireUseCase
                    .execute(requestType: requestType,
                             characterNumber: characterNumber,
                             completion: completion)
                    .subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                        self?.handleCharacterData(usecase)
                    }
        }
    }
    
    func fetchHomeworld(requestType: RequestType, url: String, completion: @escaping HomeworldResponse) {
        switch requestType {
            case .urlsession:
                self.fetchHomeworldWithURLSessionUseCase
                    .execute(requestType: requestType,
                             url: url,
                             completion: completion)
                    .subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                        self?.handleHomeworldData(usecase)
                    }
            case .alamofire:
                fetchHomeworldWithAlamofireUseCase
                    .execute(requestType: requestType,
                             url: url,
                             completion: completion)
                    .subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                        self?.handleHomeworldData(usecase)
                    }
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func handleCharacterData(_ data: Result<Character, FetchCharacterDataUseCaseError>) {
        switch data {
        case .success(let model):
            characterDataObserver.onNext(model)
        case .failure(let error):
            errorFetchCharacterData.onNext(error.localizedDescription)
        }
    }
    
    private func handleHomeworldData(_ data: Result<Homeworld, FetchHomeworldDataUseCaseError>) {
        switch data {
        case .success(let model):
            homeworldDataObserver.onNext(model)
            viewStateObserver.onNext(.idle)
        case .failure(let error):
            errorFetchHomeworldData.onNext(error.localizedDescription)
        }
    }
}
