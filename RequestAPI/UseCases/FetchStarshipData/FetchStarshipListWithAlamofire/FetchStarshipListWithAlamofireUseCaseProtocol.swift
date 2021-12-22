//
//  FetchStarshipListWithAlamofireUseCaseProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation
import RxSwift

protocol FetchStarshipListWithAlamofireUseCaseProtocol {
    typealias CharacterResponse = (Character) -> Void
    func execute(requestType: RequestType, characterNumber: Int, completion: @escaping CharacterResponse) -> Observable<Result<Character, FetchStarshipDataUseCaseError>>
}