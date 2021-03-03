//
//  Binding+Force.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension Binding {

    public func forceUnwrap<Wrapped>() -> Binding<Wrapped> where Value == Wrapped? {
        .init(get: { self.wrappedValue! },
              set: { self.wrappedValue = $0 })
    }

    public func force<T>(as type: T.Type) -> Binding<T> {
        .init(
            get: { self.wrappedValue as! T },
            set: { self.wrappedValue = $0 as! Value }
        )
    }

    public func `default`<Wrapped>(_ value: Wrapped) -> Binding<Wrapped> where Value == Wrapped? {
        .init(
            get: { self.wrappedValue ?? value },
            set: { self.wrappedValue = $0 }
        )
    }

}

