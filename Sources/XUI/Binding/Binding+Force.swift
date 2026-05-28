//
//  Binding+Force.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

// The operations in this file are **unsafe in both directions** — reads trap on `nil`
// or type mismatch, and writes trap on type mismatch. Prefer safe alternatives (`if let`,
// `as?`, `Binding.map`) wherever possible.

extension Binding {

    /// Returns a `Binding<Wrapped>` that force-unwraps the underlying optional binding.
    /// Reading the binding when the underlying value is `nil` will trap.
    public func forceUnwrap<Wrapped>() -> Binding<Wrapped> where Value == Wrapped? {
        .init(get: { self.wrappedValue! },
              set: { self.wrappedValue = $0 })
    }

    /// Returns a `Binding<T>` that force-casts the underlying binding to `T`. Both reads
    /// (`Value as! T`) and writes (`T as! Value`) trap on type mismatch.
    public func force<T>(as type: T.Type) -> Binding<T> {
        .init(
            get: { self.wrappedValue as! T },
            set: { self.wrappedValue = $0 as! Value }
        )
    }

}
