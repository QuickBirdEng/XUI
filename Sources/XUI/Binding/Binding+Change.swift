//
//  Binding+Change.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

// Each of the methods below returns a *new* derived `Binding`; they do not mutate the
// original. The original binding remains usable and unchanged.

extension Binding {

    /// Returns a derived `Binding` that invokes `willSet` immediately **before** writing
    /// the new value through to the original binding.
    public func willSet(_ willSet: @escaping (Value) -> Void) -> Binding {
        .init(
            get: { self.wrappedValue },
            set: { newValue in
                willSet(newValue)
                self.wrappedValue = newValue
            }
        )
    }

    /// Returns a derived `Binding` that invokes `didSet` immediately **after** writing the
    /// new value through to the original binding.
    public func didSet(_ didSet: @escaping (Value) -> Void) -> Binding {
        .init(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                didSet(newValue)
            }
        )
    }

    /// Returns a derived `Binding` that **silently drops** the write if `ensure` returns
    /// `false`. The original binding's setter is only invoked when the predicate succeeds.
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

    /// Returns a derived `Binding` that asserts `assertion` on **both** read and write.
    /// The assertion is compiled out in release builds — use this to catch invariant
    /// violations during development without affecting shipping behaviour.
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

    /// Returns a `Binding<V>` that is a bidirectional projection of the underlying binding.
    /// `get` converts `Value → V` on read; `set` converts `V → Value` on write.
    public func map<V>(get: @escaping (Value) -> V, set: @escaping (V) -> Value) -> Binding<V> {
        .init(
            get: { get(self.wrappedValue) },
            set: { self.wrappedValue = set($0) }
        )
    }

    /// Returns a derived `Binding` that applies `map` to values on read only; writes pass
    /// through unchanged.
    public func alterGet(_ map: @escaping (Value) -> Value) -> Binding {
        .init(
            get: { map(self.wrappedValue) },
            set: { self.wrappedValue = $0 }
        )
    }

    /// Returns a derived `Binding` that applies `map` to values on write only; reads pass
    /// through unchanged.
    public func alterSet(_ map: @escaping (Value) -> Value) -> Binding {
        .init(
            get: { self.wrappedValue },
            set: { self.wrappedValue = map($0) }
        )
    }

}
