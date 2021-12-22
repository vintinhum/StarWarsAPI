//
//  String.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 02/12/21.
//

import Foundation

extension StringProtocol {
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}
