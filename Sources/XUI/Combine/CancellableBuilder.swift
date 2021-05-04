//
//  CancellableBuilder.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

/// `CancellableBuilder` is a function builder to combine `Cancellable`
/// objects into one `AnyCancellable`.
///
/// Possible use case: Storing multiple cancellables in a collection
/// without writing `.store(in:)` for each subscription separately.
@resultBuilder
public struct CancellableBuilder {

    public static func buildBlock(_ components: [Cancellable]...) -> [Cancellable] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: Cancellable) -> [Cancellable] {
        [expression]
    }

    public static func buildOptional(_ component: [Cancellable]?) -> [Cancellable] {
        component ?? []
    }

    public static func buildEither(first component: Cancellable) -> [Cancellable] {
        [component]
    }

    public static func buildEither(second component: Cancellable) -> [Cancellable] {
        [component]
    }

    public static func buildEither(first component: [Cancellable]) -> [Cancellable] {
        component
    }

    public static func buildEither(second component: [Cancellable]) -> [Cancellable] {
        component
    }

    public static func buildArray(_ components: [Cancellable]) -> [Cancellable] {
        components
    }

    public static func buildLimitedAvailability(_ component: [Cancellable]) -> [Cancellable] {
        component
    }

    public static func buildFinalResult(_ component: [Cancellable]) -> [AnyCancellable] {
        component.map { $0.eraseToAnyCancellable() }
    }

}

extension Cancellable {

    fileprivate func eraseToAnyCancellable() -> AnyCancellable {
        if let anyCancellable = self as? AnyCancellable {
            return anyCancellable
        } else {
            return AnyCancellable(self)
        }
    }

}

extension RangeReplaceableCollection where Element == AnyCancellable {

    /// This method can be used to store multiple `Cancellable` objects
    /// from different subscriptions in a collection of `AnyCancellable`.
    public mutating func insert(@CancellableBuilder _ builder: () -> [AnyCancellable]) {
        builder().forEach { $0.store(in: &self) }
    }

}

extension Set where Element == AnyCancellable {

    /// This method can be used to store multiple `Cancellable` objects
    /// from different subscriptions in a set of `AnyCancellable`.
    public mutating func insert(@CancellableBuilder _ builder: () -> [AnyCancellable]) {
        builder().forEach { $0.store(in: &self) }
    }

}

