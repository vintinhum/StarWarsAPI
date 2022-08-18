//
//  CharacterDetailViewModel.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 01/12/21.
//

import UIKit
import Alamofire
import RxSwift



public enum State {
    case idle
    case loading
}

class CharacterDetailViewModel: CharacterDetailViewModelProtocol {

    // MARK: - PRIVATE PROPERTIES
    
    private var model: CharacterDetailModel
    private let disposeBag = DisposeBag()
    private let fetchCharacterWithURLUseCase: FetchCharacterWithURLSessionUseCaseProtocol
    private let fetchCharacterWithAlamofireUseCase: FetchCharacterWithAlamofireUseCaseProtocol
    private let fetchHomeworldWithURLSessionUseCase: FetchHomeworldWithURLSessionUseCaseProtocol
    private let fetchHomeworldWithAlamofireUseCase: FetchHomeworldWithAlamofireUseCaseProtocol
    
    // MARK: - OBSERVERS
    
    var characterDataObserver: PublishSubject<Character> = .init()
    var errorFetchCharacterData: PublishSubject<String> = .init()
    var homeworldDataObserver: PublishSubject<Homeworld> = .init()
    var errorFetchHomeworldData:PublishSubject<String> = .init()
    var viewStateObserver: BehaviorSubject<State> = .init(value: .loading)
    
    // MARK: - INITIALIZERS
    
    init(model: CharacterDetailModel,
         fetchCharacterWithURLUseCase: FetchCharacterWithURLSessionUseCaseProtocol,
         fetchCharacterWithAlamofireUseCase: FetchCharacterWithAlamofireUseCaseProtocol,
         fetchHomeworldWithURLSessionUseCase: FetchHomeworldWithURLSessionUseCaseProtocol,
         fetchHomeworldWithAlamofireUseCase: FetchHomeworldWithAlamofireUseCaseProtocol) {
        self.model = model
        self.fetchCharacterWithURLUseCase = fetchCharacterWithURLUseCase
        self.fetchCharacterWithAlamofireUseCase = fetchCharacterWithAlamofireUseCase
        self.fetchHomeworldWithURLSessionUseCase = fetchHomeworldWithURLSessionUseCase
        self.fetchHomeworldWithAlamofireUseCase = fetchHomeworldWithAlamofireUseCase
    }
    
    // MARK: - PUBLIC METHODS
    
    func fetchCharacterData() {
        let body: CharacterRequestModel = .init(characterNumber: model.characterNumber)
        switch model.requestType {
        case .urlsession: createURLSessionCharacterRequest(with: body)
        case .alamofire: createAlamofireCharacterRequest(with: body)
        }
    }
    
    func fetchHomeworld(with url: String) {
        let body: HomeworldRequestModel = .init(url: url)
        switch model.requestType {
            case .urlsession: createURLSessionHomeworldRequest(with: body)
            case .alamofire: createAlamofireHomeworldRequest(with: body)
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    private func createURLSessionCharacterRequest(with body: CharacterRequestModel) {
        self.fetchCharacterWithURLUseCase.execute(body: body).subscribeOnMainDisposed(by: disposeBag) { [weak self] in
                self?.handleCharacterData($0)
        }
    }
    
    private func createAlamofireCharacterRequest(with body: CharacterRequestModel) {
        self.fetchCharacterWithAlamofireUseCase.execute(body: body).subscribeOnMainDisposed(by: disposeBag) { [weak self] in
                self?.handleCharacterData($0)
        }
    }
    
    private func createURLSessionHomeworldRequest(with body: HomeworldRequestModel) {
        self.fetchHomeworldWithURLSessionUseCase.execute(body: body).subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                self?.handleHomeworldData(usecase)
        }
    }
    
    private func createAlamofireHomeworldRequest(with body: HomeworldRequestModel) {
        fetchHomeworldWithAlamofireUseCase.execute(body: body).subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                self?.handleHomeworldData(usecase)
        }
    }
    
    // MARK: - HANDLERS
    
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
