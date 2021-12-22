//
//  FilmListViewModel.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 02/12/21.
//

import Alamofire
import RxSwift

protocol FilmListViewModelProtocol: AnyObject {
    typealias CharacterResponse = (Character) -> Void
    func fetchFilmData(requestType: RequestType, for characterNumber: Int, _ completion: @escaping CharacterResponse)
}

class FilmListViewModel: FilmListViewModelProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let disposeBag = DisposeBag()
    private let fetchFilmListWithURLSessionUseCase: FetchFilmListWithURLSessionUseCaseProtocol
    private let fetchFilmListWithAlamofireUseCase: FetchFilmListWithAlamofireUseCaseProtocol
    
    // MARK: - OBSERVERS
    
    let filmDataObserver = PublishSubject<Character>()
    let errorFetchFilmData = PublishSubject<String>()
    let viewStateObserver = PublishSubject<State>()
    
    // MARK: - INITIALIZERS
    
    init(fetchFilmListWithURLSessionUseCase: FetchFilmListWithURLSessionUseCaseProtocol, fetchFilmListWithAlamofireUseCase: FetchFilmListWithAlamofireUseCaseProtocol) {
        self.fetchFilmListWithURLSessionUseCase = fetchFilmListWithURLSessionUseCase
        self.fetchFilmListWithAlamofireUseCase = fetchFilmListWithAlamofireUseCase
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func fetchFilmData(requestType: RequestType, for characterNumber: Int, _ completion: @escaping CharacterResponse) {
        switch requestType {
            case .urlsession:
                fetchFilmListWithURLSessionUseCase
                    .execute(requestType: requestType,
                             characterNumber: characterNumber,
                             completion: completion)
                    .subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                        self?.handleFilmData(usecase)
                    }
            case .alamofire:
                fetchFilmListWithAlamofireUseCase
                    .execute(requestType: requestType,
                             characterNumber: characterNumber,
                             completion: completion)
                    .subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                        self?.handleFilmData(usecase)
                    }
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func handleFilmData(_ data: Result<Character, FetchFilmDataUseCaseError>) {
        switch data {
        case .success(let model):
            filmDataObserver.onNext(model)
            viewStateObserver.onNext(.idle)
        case .failure(let error):
            errorFetchFilmData.onNext(error.localizedDescription)
        }
    }
}
