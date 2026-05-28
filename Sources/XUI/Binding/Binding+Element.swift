//
//  Binding+Element.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension Binding where Value: RangeReplaceableCollection {

    /// Returns a `Binding<Element?>` projecting the first element of the underlying
    /// collection that matches `condition`.
    ///
    /// Write semantics:
    /// - Setting a non-`nil` value while no element matches **appends** the new element.
    /// - Setting a non-`nil` value while an element matches **replaces** the matching element
    ///   in place.
    /// - Setting `nil` **removes** the matching element (if any).
    public func first(
        where condition: @escaping (Value.Element) -> Bool
    ) -> Binding<Value.Element?> {

        Binding<Value.Element?>(
            get: { self.wrappedValue.first(where: condition) },
            set: { newValue in
                guard let index = self.wrappedValue.firstIndex(where: condition) else {
                    if let value = newValue {
                        self.wrappedValue.append(value)
                    }
                    return
                }
                self.wrappedValue.remove(at: index)
                if let value = newValue {
                    self.wrappedValue.insert(value, at: index)
                }
            }
        )
    }

    /// Returns a `Binding<Element?>` projecting the first element whose value at `keyPath`
    /// equals `value`. Same append/replace/remove write semantics as `first(where:)`.
    public func first<E: Equatable>(
        where keyPath: KeyPath<Value.Element, E>,
        equals value: E
    ) -> Binding<Value.Element?> {

        first { $0[keyPath: keyPath] == value }
    }

    /// Returns a `Binding<Element?>` projecting the first element equal to `value`. Same
    /// append/replace/remove write semantics as `first(where:)`.
    public func first(
        equalTo value: Value.Element
    ) -> Binding<Value.Element?> where Value.Element: Equatable {

        first { $0 == value }
    }

    /// Returns a `Binding<T?>` projecting the first element that is castable to `T`.
    ///
    /// The cast is performed unsafely (via `force(as:)`) — if the matching element's actual
    /// type does not match `T` exactly on a write-through, the program will trap.
    public func first<T>(as: T.Type) -> Binding<T?> {

        first(where: { $0 is T })
            .force(as: T?.self)
    }

}
