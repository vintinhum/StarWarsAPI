//
//  StarshipListViewModel.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 06/12/21.
//

import Alamofire
import RxSwift

class StarshipListViewModel: StarshipListViewModelProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var model: StarshipListModel
    private let disposeBag = DisposeBag()
    private let fetchStarshipListWithURLSessionUseCase: FetchStarshipListWithURLSessionUseCaseProtocol
    private let fetchStarshipListWithAlamofireUseCase: FetchStarshipListWithAlamofireUseCaseProtocol
    
    // MARK: - OBSERVERS
    
    var starshipDataObserver: PublishSubject<Character> = .init()
    var errorFetchStarshipData: PublishSubject<String> = .init()
    var viewStateObserver: BehaviorSubject<State> = .init(value: .loading)
    
    //MARK: - INITIALIZERS
    
    init(model: StarshipListModel,
         fetchStarshipListWithURLSessionUseCase: FetchStarshipListWithURLSessionUseCaseProtocol,
         fetchStarshipListWithAlamofireUseCase: FetchStarshipListWithAlamofireUseCaseProtocol) {
        self.model = model
        self.fetchStarshipListWithURLSessionUseCase = fetchStarshipListWithURLSessionUseCase
        self.fetchStarshipListWithAlamofireUseCase = fetchStarshipListWithAlamofireUseCase
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func fetchStarshipData() {
        let body: CharacterRequestModel = .init(characterNumber: model.characterNumber)
        switch model.requestType {
        case .urlsession: createURLSessionStarshipRequest(with: body)
        case .alamofire: createAlamofireStarshipRequest(with: body)
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func createURLSessionStarshipRequest(with body: CharacterRequestModel) {
        fetchStarshipListWithURLSessionUseCase.execute(body: body).subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                self?.handleStarshipData(usecase)
        }
    }
    
    private func createAlamofireStarshipRequest(with body: CharacterRequestModel) {
        fetchStarshipListWithAlamofireUseCase.execute(body: body).subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                self?.handleStarshipData(usecase)
        }
    }
    
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
