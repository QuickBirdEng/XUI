//
//  Result+Combine.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension Publisher {

    ///
    /// Maps the output and/or failure of a publisher to a `Result<Output, Failure>`
    /// output without completing the publisher when receiving a failure.
    ///
    public func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        map(Result<Output, Failure>.success)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }

    ///
    /// Maps a given `Result` output to values of the same type with separate
    /// closures for the success and failure case.
    ///
    /// Since errors are transformed into values, the publisher will no longer complete
    /// when errors occur, but instead continue the subscription.
    ///
    public func mapResult<Value>(
        success: @escaping (Output) -> Value,
        failure: @escaping (Failure) -> Value) -> AnyPublisher<Value, Never> {

        asResult()
            .map { $0.map(success: success, failure: failure) }
            .eraseToAnyPublisher()
    }

    ///
    /// Maps a given `Result` output to values of the same type with separate
    /// closures for the success and failure case.
    ///
    /// Since errors are transformed into values, the publisher will no longer complete
    /// when errors occur, but instead continue the subscription, unless the given closures
    /// are throwing an error.
    ///
    public func tryMapResult<Value>(
        success: @escaping (Output) throws -> Value,
        failure: @escaping (Failure) throws -> Value) -> AnyPublisher<Value, Error> {

        asResult()
            .tryMap { try $0.map(success: success, failure: failure) }
            .eraseToAnyPublisher()
    }

}

extension Result {

    /// Maps a given `Result` to values of the same type with separate closures
    /// for the success and failure case.
    public func map<T>(success successClosure: (Success) throws -> T,
                       failure failureClosure: (Failure) throws -> T) rethrows -> T {
        switch self {
        case let .success(success):
            return try successClosure(success)
        case let .failure(failure):
            return try failureClosure(failure)
        }
    }

}
