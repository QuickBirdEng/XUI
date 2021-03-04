//
//  Binding+Change.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension Binding {

    public func willSet(_ willSet: @escaping (Value) -> Void) -> Binding {
        .init(
            get: { self.wrappedValue },
            set: { newValue in
                willSet(newValue)
                self.wrappedValue = newValue
            }
        )
    }

    public func didSet(_ didSet: @escaping (Value) -> Void) -> Binding {
        .init(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                didSet(newValue)
            }
        )
    }

    public func ensure(_ ensure: @escaping (Value) -> Bool) -> Binding {
        .init(
            get: { self.wrappedValue },
            set: { newValue in
                guard ensure(newValue) else {
                    return
                }
                self.wrappedValue = newValue
            }
        )
    }

    public func assert(_ assertion: @escaping (Value) -> Bool) -> Binding {
        .init(
            get: {
                let value = self.wrappedValue
                Swift.assert(assertion(value))
                return value
            },
            set: { newValue in
                Swift.assert(assertion(newValue))
                self.wrappedValue = newValue
            }
        )
    }

    public func map<V>(get: @escaping (Value) -> V,
                       set: @escaping (inout Value, V) -> Void) -> Binding<V> {
        .init(
            get: { get(self.wrappedValue) },
            set: { set(&self.wrappedValue, $0) }
        )
    }

    public func alterGet(_ map: @escaping (Value) -> Value) -> Binding {
        .init(
            get: { map(self.wrappedValue) },
            set: { self.wrappedValue = $0 }
        )
    }

    public func alterSet(_ map: @escaping (Value) -> Value) -> Binding {
        .init(
            get: { self.wrappedValue },
            set: { self.wrappedValue = map($0) }
        )
    }

    public func onlySetOnChange(_ isEqual: @escaping (Value, Value) -> Bool) -> Binding {
        .init(
            get: { self.wrappedValue },
            set: { newValue in
                guard !isEqual(self.wrappedValue, newValue) else {
                    return
                }
                self.wrappedValue = newValue
            }
        )
    }

    public func onlySetOnChange<V>(
        of keyPath: KeyPath<Value, V>
    ) -> Binding where V: Equatable {

        onlySetOnChange { $0[keyPath: keyPath] == $1[keyPath: keyPath] }
    }

    public func onlySetOnChange() -> Binding where Value: Equatable {
        onlySetOnChange(==)
    }

}
