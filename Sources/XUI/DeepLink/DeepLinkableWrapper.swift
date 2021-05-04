//
//  DeepLinkableWrapper.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

public protocol DeepLinkableWrapper {
    var content: Any { get }
}

extension Published: DeepLinkableWrapper {

    public var content: Any {
        guard let value = Mirror(reflecting: self).descendant("storage", "value") else {
            assertionFailure("We could not extract a wrappedValue from a Published property wrapper.")
            return ()
        }
        return value
    }

}

extension Binding: DeepLinkableWrapper {
    public var content: Any { wrappedValue }
}

extension State: DeepLinkableWrapper {
    public var content: Any { wrappedValue }
}

extension ObservedObject: DeepLinkableWrapper {
    public var content: Any { wrappedValue }
}

extension EnvironmentObject: DeepLinkableWrapper {
    public var content: Any { wrappedValue }
}

extension Store: DeepLinkableWrapper {
    public var content: Any { wrappedValue }
}

extension Optional: DeepLinkableWrapper {
    public var content: Any { flatMap { $0 } ?? () }
}
