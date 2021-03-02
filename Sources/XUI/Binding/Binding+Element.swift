//
//  Binding+Element.swift
//  XUI
//  
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension Binding where Value: RangeReplaceableCollection {

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

    public func first<E: Equatable>(
        where keyPath: KeyPath<Value.Element, E>,
        equals value: E
    ) -> Binding<Value.Element?> {

        first { $0[keyPath: keyPath] == value }
    }

    func first(
        equalTo value: Value.Element
    ) -> Binding<Value.Element?> where Value.Element: Equatable {

        first { $0 == value }
    }

    func first<T>(as: T.Type) -> Binding<T?> {

        first(where: { $0 is T })
            .force(as: T?.self)
    }

}
