//
//  FetchHomeworldDataWithAlamofireUseCaseProtocol.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation
import RxSwift

protocol FetchHomeworldWithAlamofireUseCaseProtocol {
    func execute(body: HomeworldRequestModel) -> Observable<Result<Homeworld, FetchHomeworldDataUseCaseError>>
}
