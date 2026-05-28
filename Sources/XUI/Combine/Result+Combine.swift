//
//  Result+Combine.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension Publisher {

    /// Converts the publisher into one that emits each output as `.success` and any failure
    /// as a `.failure` value.
    ///
    /// On upstream failure, the failure is delivered as a value (`.failure(...)`) and the
    /// subscription then completes normally — i.e. the downstream is not torn down by a
    /// Combine completion failure, but it still receives at most one trailing value before
    /// completion.
    @available(*, deprecated, message: "Prefer async/await with do/try/catch.")
    public func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        map(Result<Output, Failure>.success)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }

    /// Reduces each output and any failure to values of a common type `Value`, using
    /// separate closures for the success and failure cases.
    ///
    /// On upstream failure, the failure is mapped through `failure` and emitted as a value;
    /// the subscription then completes normally.
    @available(*, deprecated, message: "Prefer async/await with do/try/catch.")
    public func mapResult<Value>(
        success: @escaping (Output) -> Value,
        failure: @escaping (Failure) -> Value) -> AnyPublisher<Value, Never> {

        asResult()
            .map { $0.map(success: success, failure: failure) }
            .eraseToAnyPublisher()
    }

    /// Throwing variant of `mapResult(success:failure:)`. If either closure throws, the
    /// resulting publisher fails with the thrown error.
    @available(*, deprecated, message: "Prefer async/await with do/try/catch.")
    public func tryMapResult<Value>(
        success: @escaping (Output) throws -> Value,
        failure: @escaping (Failure) throws -> Value) -> AnyPublisher<Value, Error> {

        asResult()
            .tryMap { try $0.map(success: success, failure: failure) }
            .eraseToAnyPublisher()
    }

}

extension Result {

    /// Reduces the `Result` to a single value of type `T` by applying either `successClosure`
    /// or `failureClosure`.
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
