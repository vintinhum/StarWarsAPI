//
//  FetchHomeworldDataWithAlamofireUseCaseProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation
import RxSwift

protocol FetchHomeworldWithAlamofireUseCaseProtocol {
    typealias HomeworldResponse = (Homeworld) -> Void
    func execute(requestType: RequestType, url: String, completion: @escaping HomeworldResponse) -> Observable<Result<Homeworld, FetchHomeworldDataUseCaseError>>
}
