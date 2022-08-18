//
//  CharacterListViewModel.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import Foundation
import RxSwift

class CharacterListViewModel: CharacterListViewModelProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private var disposeBag = DisposeBag()
    private let fetchAllCharactersUseCase: FetchAllCharactersDataUseCaseProtocol
    private let fetchAllCharactersWithURLUseCase: FetchAllCharactersDataWithURLUseCaseProtocol
    private let fetchHomeworldDataUseCase: FetchHomeworldWithURLSessionUseCaseProtocol
    private var characters: [Character] = []
    private var homeworlds: [Homeworld] = []
    
    // MARK: - OBSREVERS
    
    var viewStateObserver: BehaviorSubject<State> = .init(value: .loading)
    var characterListDataObserver: PublishSubject<[Character]> = .init()
    var homeworldListDataObserver: PublishSubject<[Homeworld]> = .init()
    var characterListErrorObserver: PublishSubject<String> = .init()
    
    // MARK: - INITIALIZERS
    
    init(fetchAllCharactersUseCase: FetchAllCharactersDataUseCaseProtocol,
         fetchAllCharactersWithURLUseCase: FetchAllCharactersDataWithURLUseCaseProtocol,
         fetchHomeworldDataUseCase: FetchHomeworldWithURLSessionUseCaseProtocol) {
        self.fetchAllCharactersUseCase = fetchAllCharactersUseCase
        self.fetchAllCharactersWithURLUseCase = fetchAllCharactersWithURLUseCase
        self.fetchHomeworldDataUseCase = fetchHomeworldDataUseCase
    }
    
    // MARK: - PUBLIC METHODS
    
    func retrieveCharacters() {
        self.fetchAllCharactersUseCase.execute().subscribeOnMainDisposed(by: disposeBag) { [weak self] in
            guard let self = self else { return }
            self.handleCharactersData($0)
        }
    }
    
    func retrieveHomeworlds(for characters: [Character]) {
        let myGroup = DispatchGroup()
        characters.forEach { character in
            myGroup.enter()
            let model: HomeworldRequestModel = .init(url: character.homeworld)
            createHomeworldRequest(model: model)
            myGroup.leave()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            self.homeworldListDataObserver.onNext(self.homeworlds)
            self.viewStateObserver.onNext(.idle)
        }
    }
    
    // MARK: - HANDLERS
    
    private func createCharacterPaginationRequest(with url: String) {
        let body: CharacterListRequestModel = .init(url: url)
        fetchAllCharactersWithURLUseCase.execute(body: body).subscribeOnMainDisposed(by: disposeBag) { [weak self] in
            guard let self = self else { return }
            self.handleCharactersData($0)
        }
    }
    
    private func createHomeworldRequest(model: HomeworldRequestModel) {
        fetchHomeworldDataUseCase.execute(body: model).subscribeOnMainDisposed(by: disposeBag) { [weak self] in
            guard let self = self else { return }
            self.handleHomeworldsData($0)
        }
    }
    
    private func handleCharactersData(_ data: Result<CharacterListResponse, FetchAllCharactersDataUseCaseError>) {
        switch data {
        case .success(let data):
            characters.append(contentsOf: data.results)
            if let nextPageURL = data.next {
                createCharacterPaginationRequest(with: nextPageURL)
                break
            }
            characterListDataObserver.onNext(characters)
        case .failure(let error):
            characterListErrorObserver.onNext(error.localizedDescription)
        }
    }
    
    private func handleHomeworldsData(_ data: Result<Homeworld, FetchHomeworldDataUseCaseError>) {
        switch data {
        case .success(let data):
            homeworlds.append(data)
        case .failure(let error):
            characterListErrorObserver.onNext(error.localizedDescription)
        }
    }
    
}
