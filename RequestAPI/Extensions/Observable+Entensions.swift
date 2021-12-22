//
//  Observable+Entensions.swift
//  RequestAPI
//
//  Created by Vitor Barrios Luis De Albuquerque  on 20/12/21.
//

import Foundation
#if os(iOS)
import RxSwift
#elseif os(watchOS)
import RxSwiftWatch
#endif

extension Observable {

    public func subscribeOnMainDisposed(by disposeBag: DisposeBag, onNext: ((Observable.Element) -> Void)? = nil) {
        subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global(qos: .background)))
        .observe(on: ConcurrentMainScheduler.instance)
        .subscribe(onNext: onNext)
        .disposed(by: disposeBag)
    }

    public func subscribeOnMainDisposed(by disposeBag: DisposeBag, onNext: ((Observable.Element) -> Void)? = nil, onError: ((Error) -> Void)? = nil) {
        subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global(qos: .background)))
        .observe(on: ConcurrentMainScheduler.instance)
        .subscribe(onNext: onNext, onError: onError)
        .disposed(by: disposeBag)
    }

    public func subscribe(disposeBag: DisposeBag, onNext: ((Observable.Element) -> Void)? = nil) {
        subscribe(onNext: onNext)
        .disposed(by: disposeBag)
    }
}

extension BehaviorSubject {
    public func safeValue<T>() -> T? where Element == T? {
        do {
            guard let value = try self.value() else {
                return nil
            }
            return value
        } catch {
            return nil
        }
    }

    public func currentValue() -> Element? {
        guard let value = try? self.value() else {
            return nil
        }
        return value
    }
}
