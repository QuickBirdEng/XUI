//
//  Binding+ObjectIdentifiable.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

import SwiftUI

extension Binding {

    func objectIdentifiable<T>() -> Binding<ObjectIdentifiable?> where Value == T? {
        .init(
            get: {
                wrappedValue.map { value in
                    ObjectIdentifiable(value)
                }
            },
            set: { newValue in
                if newValue == nil {
                    wrappedValue = nil
                }
            }
        )
    }

}
