//
//  FetchAllCharactersDataWithURLUseCase.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 16/08/22.
//

import RxSwift

class FetchAllCharactersDataWithURLUseCase {
    
    // MARK: - ALIASES
    
    typealias UseCaseEventType = Result<CharacterListResponse, FetchAllCharactersDataUseCaseError>
    typealias ServiceResultReturningType = Result<CharacterListResponse, ServiceError>
    
    // MARK: - PROPERTIES
    
    private let service: ServiceProtocol
    
    // MARK: - INITIALIZERS
    
    init(service: ServiceProtocol) {
        self.service = service
    }
}

extension FetchAllCharactersDataWithURLUseCase: FetchAllCharactersDataWithURLUseCaseProtocol {
    
    // MARK: - PUBLIC METHODS
    
    func execute(body: CharacterListRequestModel) -> Observable<Result<CharacterListResponse, FetchAllCharactersDataUseCaseError>> {
        request(body: body)
            .flatMap { [unowned self] in self.handleResult($0) }
            .catch { [unowned self] in self.handleError($0) }
    }
    
    // MARK: - PRIVATE METHODS
    
    private func request(body: CharacterListRequestModel) -> Observable<ServiceResultReturningType> {
        return Observable.create { [weak self] observer in
            let request: Request = .characterListWithURL(request: body)
            self?.service.fetchCharacterList(request: request) { serviceResult in
                observer.onNext(serviceResult)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    // MARK: - HANDLERS
    
    private func handleResult(_ serviceResult: ServiceResultReturningType) -> Observable<UseCaseEventType> {
        switch serviceResult {
            case .success(let data): return Observable.just(.success(data))
            case .failure(let error): return Observable.error(error)
        }
    }
    
    private func handleError(_ error: Error) -> Observable<UseCaseEventType> {
        if let serviceError = error as? ServiceError {
            return Observable.just(.failure(.message(serviceError.localizedDescription)))
        }
        return Observable.just(.failure(.message(error.localizedDescription)))
    }
}
