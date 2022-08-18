//
//  FetchStarshipListWithURLSessionUseCase.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation
import RxSwift

class FetchStarshipListWithURLSessionUseCase {
    
    // MARK: - ALIASES
    
    typealias UseCaseEventType = Result<Character, FetchStarshipDataUseCaseError>
    typealias ServiceResultReturningType = Result<Character, ServiceError>
    
    // MARK: - PROPERTIES
    
    private let service: ServiceProtocol
    
    // MARK: - INITIALIZERS
    
    init(service: ServiceProtocol) {
        self.service = service
    }
}

extension FetchStarshipListWithURLSessionUseCase: FetchStarshipListWithURLSessionUseCaseProtocol {
    
    // MARK: - PUBLIC FUNCTIONS
    
    func execute(body: CharacterRequestModel) -> Observable<UseCaseEventType> {
        request(body: body)
            .flatMap { [unowned self] in self.handleResult($0) }
            .catch { [unowned self] in self.handleError($0) }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func request(body: CharacterRequestModel) -> Observable<ServiceResultReturningType> {
        return Observable.create { [weak self] observer in
            let request: Request = .character(request: body)
            self?.service.fetchCaracter(request: request) { serviceResult in
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
