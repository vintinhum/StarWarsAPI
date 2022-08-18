//
//  ServiceError.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 20/12/21.
//

import Foundation

public enum ServiceError: Error {
    case raw(Error?)
    case empty
    case serialized(message: String?, errorCode: String?, statusCode: Int?)
}

