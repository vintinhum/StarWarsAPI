//
//  DependencyProvider.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 17/12/21.
//

import Swinject

public class DependencyProvider {
    
    public let container = Container()
    public let assembler: Assembler
    
    public init() {
        assembler = Assembler([MyAssembly()], container: container)
    }
    
    public func add(_ assemblies: [Assembly]) {
        assembler.apply(assemblies: assemblies)
    }
}
