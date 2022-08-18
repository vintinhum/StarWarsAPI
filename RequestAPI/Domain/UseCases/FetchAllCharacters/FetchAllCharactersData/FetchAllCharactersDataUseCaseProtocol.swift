//
//  FetchAllCharactersDataUseCaseProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 15/08/22.
//

import RxSwift

protocol FetchAllCharactersDataUseCaseProtocol {
    func execute() -> Observable<Result<CharacterListResponse, FetchAllCharactersDataUseCaseError>>
}
