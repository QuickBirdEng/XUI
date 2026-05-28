//
//  View+NavigationDestination.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

@available(iOS 16, macOS 13, watchOS 9, tvOS 16, *)
extension View {

    /// Pushes `destination(model)` onto the enclosing `NavigationStack` when
    /// `model.wrappedValue` is non-nil; pops it (and resets the binding to nil) when the
    /// navigation is dismissed.
    ///
    /// The `NavigationStack` equivalent of `View.navigation(model:destination:)`. Use this on
    /// iOS 16+ wherever you previously used `navigation(model:)`.
    public func navigationDestination<Model, Destination: View>(
        model: Binding<Model?>,
        @ViewBuilder destination: @escaping (Model) -> Destination
    ) -> some View {

        let isPresented = Binding(
            get: { model.wrappedValue != nil },
            set: { value in
                if !value {
                    model.wrappedValue = nil
                }
            }
        )
        return navigationDestination(isPresented: isPresented) {
            if let value = model.wrappedValue {
                destination(value)
            }
        }
    }

}
