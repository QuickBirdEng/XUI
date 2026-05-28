//
//  View+Sheet.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension View {

    /// Presents a sheet when `model.wrappedValue` is non-nil. Setting it to nil dismisses
    /// the sheet; an interactive dismissal sets it back to nil.
    ///
    /// `Model` should be a reference type (class, or class-constrained protocol) — XUI
    /// identifies the presented item by object identity. The generic is intentionally
    /// unconstrained so that protocol-typed view models (`any MyViewModel` where
    /// `MyViewModel: AnyObject`) can be passed through; Swift's generic system would
    /// otherwise reject those at the call site because protocols don't self-conform to
    /// `AnyObject`. Passing a value-type `Model` will misbehave: SwiftUI's `Identifiable`
    /// item identity is computed from a freshly-boxed `ObjectIdentifier` on every read,
    /// causing the sheet to re-present continuously.
    public func sheet<Model, Destination: View>(
        model: Binding<Model?>,
        @ViewBuilder destination: @escaping (Model) -> Destination
    ) -> some View {

        sheet(item: model.objectIdentifiable()) { _ in
            model.wrappedValue.map(destination)
        }
    }

}
