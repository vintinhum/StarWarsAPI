//
//  FetchFilmListWithAlamofireUseCase.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation
import RxSwift

class FetchFilmListWithAlamofireUseCase {
    
    // MARK: - ALIASES
    
    typealias UseCaseEventType = Result<Character, FetchFilmDataUseCaseError>
    typealias ServiceResultReturningType = Result<Character, ServiceError>
    
    // MARK: - PROPERTIES
    
    private let networking: NetworkingProtocol
    
    // MARK: - INITIALIZERS
    
    init(networking: NetworkingProtocol) {
        self.networking = networking
    }
}

extension FetchFilmListWithAlamofireUseCase: FetchFilmListWithAlamofireUseCaseProtocol {
    
    // MARK: - PUBLIC FUNCTIONS
    
    func execute(requestType: RequestType, characterNumber: Int, completion: @escaping CharacterResponse) -> Observable<UseCaseEventType> {
        request(requestType: requestType, characterNumber: characterNumber, completion: completion)
            .flatMap { [unowned self] in self.handleResult($0) }
            .catch { [unowned self] in self.handleError($0) }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func request(requestType: RequestType, characterNumber: Int, completion: @escaping CharacterResponse) -> Observable<ServiceResultReturningType> {
        return Observable.create { [weak self] observer in
            self?.networking.fetchCaracter(requestType: requestType, characterNumber: characterNumber, completion: { serviceResult in
                observer.onNext(serviceResult)
                observer.onCompleted()
            })
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
