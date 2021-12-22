//
//  StarshipListViewModel.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 06/12/21.
//

import Alamofire
import RxSwift

protocol StarshipListViewModelProtocol: AnyObject {
    typealias CharacterResponse = (Character) -> Void
    func fetchStarshipData(requestType: RequestType, for characterNumber: Int, _ completion: @escaping CharacterResponse)
}

class StarshipListViewModel: StarshipListViewModelProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let disposeBag = DisposeBag()
    private let fetchStarshipListWithURLSessionUseCase: FetchStarshipListWithURLSessionUseCaseProtocol
    private let fetchStarshipListWithAlamofireUseCase: FetchStarshipListWithAlamofireUseCaseProtocol
    
    // MARK: - OBSERVERS
    
    let starshipDataObserver = PublishSubject<Character>()
    let errorFetchStarshipData = PublishSubject<String>()
    let viewStateObserver = PublishSubject<State>()
    
    //MARK: - INITIALIZERS
    
    init(fetchStarshipListWithURLSessionUseCase: FetchStarshipListWithURLSessionUseCaseProtocol, fetchStarshipListWithAlamofireUseCase: FetchStarshipListWithAlamofireUseCaseProtocol) {
        self.fetchStarshipListWithURLSessionUseCase = fetchStarshipListWithURLSessionUseCase
        self.fetchStarshipListWithAlamofireUseCase = fetchStarshipListWithAlamofireUseCase
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func fetchStarshipData(requestType: RequestType, for characterNumber: Int, _ completion: @escaping CharacterResponse) {
        switch requestType {
            case .urlsession:
                fetchStarshipListWithURLSessionUseCase
                    .execute(requestType: requestType,
                             characterNumber: characterNumber,
                             completion: completion)
                    .subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                        self?.handleStarshipData(usecase)
                    }
            case .alamofire:
                fetchStarshipListWithAlamofireUseCase
                    .execute(requestType: requestType,
                             characterNumber: characterNumber,
                             completion: completion)
                    .subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                        self?.handleStarshipData(usecase)
                    }
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func handleStarshipData(_ data: Result<Character, FetchStarshipDataUseCaseError>) {
        switch data {
        case .success(let model):
            starshipDataObserver.onNext(model)
            viewStateObserver.onNext(.idle)
        case .failure(let error):
            errorFetchStarshipData.onNext(error.localizedDescription)
        }
    }
}
