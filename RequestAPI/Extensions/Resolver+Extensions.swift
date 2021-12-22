//
//  Resolver+Extensions.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 14/12/21.
//

import Foundation
import Swinject

extension Resolver {
    public func resolveUnwrapping<Service>(_ serviceType: Service.Type) -> Service {
        if let resolution = resolve(serviceType) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    public func resolveUnwrapping<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service {
        if let resolution = resolve(serviceType, argument: argument) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    // swiftlint:disable function_parameter_count
    public func resolveUnwrapping<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service {
        if let resolution = resolve(serviceType, arguments: arg1, arg2) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    public func resolveUnwrapping<Service, Arg1, Arg2, Arg3>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3
    ) -> Service {
        if let resolution = resolve(serviceType, arguments: arg1, arg2, arg3) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    public func resolveUnwrapping<Service, Arg1, Arg2, Arg3, Arg4>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4
    ) -> Service {
        if let resolution = resolve(serviceType, arguments: arg1, arg2, arg3, arg4) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    public func resolveUnwrapping<Service, Arg1, Arg2, Arg3, Arg4, Arg5>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4,
        _ arg5: Arg5
    ) -> Service {
        if let resolution = resolve(serviceType, arguments: arg1, arg2, arg3, arg4, arg5) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    public func resolveUnwrapping<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4,
        _ arg5: Arg5,
        _ arg6: Arg6
    ) -> Service {
        if let resolution = resolve(serviceType, arguments: arg1, arg2, arg3, arg4, arg5, arg6) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    public func resolveUnwrapping<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4,
        _ arg5: Arg5,
        _ arg6: Arg6,
        _ arg7: Arg7
    ) -> Service {
        if let resolution = resolve(serviceType, arguments: arg1, arg2, arg3, arg4, arg5, arg6, arg7) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    public func resolveUnwrapping<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3,
        _ arg4: Arg4,
        _ arg5: Arg5,
        _ arg6: Arg6,
        _ arg7: Arg7,
        _ arg8: Arg8
    ) -> Service {
        if let resolution = resolve(serviceType, arguments: arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    public func resolveUnwrapping<Service>(_ serviceType: Service.Type, name: String) -> Service {
        if let resolution = resolve(serviceType, name: name) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }

    public func resolveUnwrapping<Service, Arg1>(_ serviceType: Service.Type, name: String?, argument: Arg1) -> Service {
        if let resolution = resolve(serviceType, name: name, argument: argument) {
            return resolution
        }
        fatalError("\(serviceType) resolution failed")
    }
}
