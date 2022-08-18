//
//  FetchAllCharactersDataWithURLUseCaseProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 16/08/22.
//

import RxSwift

protocol FetchAllCharactersDataWithURLUseCaseProtocol {
    func execute(body: CharacterListRequestModel) -> Observable<Result<CharacterListResponse, FetchAllCharactersDataUseCaseError>>
}
