//
//  FetchAllCharactersDataUseCase.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import Foundation
import RxSwift

class FetchAllCharactersDataUseCase {
    
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

extension FetchAllCharactersDataUseCase: FetchAllCharactersDataUseCaseProtocol {
    
    // MARK: - PUBLIC METHODS
    
    func execute() -> Observable<Result<CharacterListResponse, FetchAllCharactersDataUseCaseError>> {
        request()
            .flatMap { [unowned self] in self.handleResult($0) }
            .catch { [unowned self] in self.handleError($0) }
    }
    
    // MARK: - PRIVATE METHODS
    
    private func request() -> Observable<ServiceResultReturningType> {
        return Observable.create { [weak self] observer in
            let request: Request = .characterList
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
