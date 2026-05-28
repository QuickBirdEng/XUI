//
//  CancellableBuilder.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

/// A result builder that collects multiple `Cancellable` values produced by sink/assign
/// subscriptions, so they can be stored in a collection without writing `.store(in:)` at
/// each call site.
///
/// Entry points: `Set<AnyCancellable>.insert(_:)` and `RangeReplaceableCollection.insert(_:)`
/// (the variants defined in this file). Both accept any `Cancellable`-producing block, with
/// `if` / `switch` / `for` / `#available` supported inside the block.
///
/// ```swift
/// var cancellables = Set<AnyCancellable>()
/// cancellables.insert {
///     viewModel.$title.sink { print("title:", $0) }
///     viewModel.$count.sink { print("count:", $0) }
/// }
/// ```
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

    /// Stores the cancellables produced by `builder` in the collection. Each cancellable is
    /// erased to `AnyCancellable` before storage.
    public mutating func insert(@CancellableBuilder _ builder: () -> [AnyCancellable]) {
        builder().forEach { $0.store(in: &self) }
    }

}

extension Set where Element == AnyCancellable {

    /// Stores the cancellables produced by `builder` in the set. Each cancellable is erased
    /// to `AnyCancellable` before storage.
    public mutating func insert(@CancellableBuilder _ builder: () -> [AnyCancellable]) {
        builder().forEach { $0.store(in: &self) }
    }

}
