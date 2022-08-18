//
//  FetchCharacterWithURLSessionUseCaseProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation
import RxSwift

protocol FetchCharacterWithURLSessionUseCaseProtocol {
    func execute(body: CharacterRequestModel) -> Observable<Result<Character, FetchCharacterDataUseCaseError>>
}
