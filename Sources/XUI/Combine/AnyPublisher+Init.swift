//
//  AnyPublisher+Init.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension AnyPublisher {

    // MARK: Factory Methods

    public static func just(_ value: Output) -> AnyPublisher {
        Just(value)
            .mapError { _ -> Failure in }
            .eraseToAnyPublisher()
    }

    public static func failure(_ error: Failure) -> AnyPublisher {
        Fail(error: error)
            .eraseToAnyPublisher()
    }

}
