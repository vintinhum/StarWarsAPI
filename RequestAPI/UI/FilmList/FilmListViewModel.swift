//
//  FilmListViewModel.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 02/12/21.
//

import Alamofire
import RxSwift

class FilmListViewModel: FilmListViewModelProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var model: FilmListModel
    private let disposeBag = DisposeBag()
    private let fetchFilmListWithURLSessionUseCase: FetchFilmListWithURLSessionUseCaseProtocol
    private let fetchFilmListWithAlamofireUseCase: FetchFilmListWithAlamofireUseCaseProtocol
    
    // MARK: - OBSERVERS
    
    var filmDataObserver: PublishSubject<Character> = .init()
    var errorFetchFilmData: PublishSubject<String> = .init()
    var viewStateObserver: BehaviorSubject<State> = .init(value: .loading)
    
    // MARK: - INITIALIZERS
    
    init(model: FilmListModel,
         fetchFilmListWithURLSessionUseCase: FetchFilmListWithURLSessionUseCaseProtocol,
         fetchFilmListWithAlamofireUseCase: FetchFilmListWithAlamofireUseCaseProtocol) {
        self.model = model
        self.fetchFilmListWithURLSessionUseCase = fetchFilmListWithURLSessionUseCase
        self.fetchFilmListWithAlamofireUseCase = fetchFilmListWithAlamofireUseCase
    }
    
    // MARK: - PUBLIC FUNCTIONS
    
    func fetchFilmData() {
        let body: CharacterRequestModel = .init(characterNumber: model.characterNumber)
        switch model.requestType {
        case .urlsession: createURLSessionFilmRequest(with: body)
        case .alamofire: createAlamofireFilmRequest(with: body)
        }
    }
    
    func convertFilmData(with string: String) -> String {
        switch string {
        case "https://swapi.dev/api/films/1/":
            return "Episode IV: A New Hope"
        case "https://swapi.dev/api/films/2/":
            return "Episode V: The Empire Strikes Back"
        case "https://swapi.dev/api/films/3/":
            return "Episode VI: Return Of The Jedi"
        case "https://swapi.dev/api/films/4/":
            return "Episode I: The Phantom Menace"
        case "https://swapi.dev/api/films/5/":
            return "Episode II: Attack Of The Clones"
        case "https://swapi.dev/api/films/6/":
            return "Episode III: Revenge Of The Sith"
        case "https://swapi.dev/api/films/7/":
            return "Episode VII: The Force Awakens"
        case "https://swapi.dev/api/films/8/":
            return "Episode VIII: The Last Jedi"
        case "https://swapi.dev/api/films/9/":
            return "Episode IX: The Rise Of Skywalker"
        default:
            return "Film not found."
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func createURLSessionFilmRequest(with body: CharacterRequestModel) {
        fetchFilmListWithURLSessionUseCase.execute(body: body).subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                self?.handleFilmData(usecase)
        }
    }
    
    private func createAlamofireFilmRequest(with body: CharacterRequestModel) {
        fetchFilmListWithAlamofireUseCase.execute(body: body).subscribeOnMainDisposed(by: disposeBag) { [weak self] usecase in
                self?.handleFilmData(usecase)
        }
    }
    
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
