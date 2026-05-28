//
//  NavigationLink.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension NavigationLink {

    /// Creates a `NavigationLink` whose destination is derived from an optional model
    /// binding. When `model` is non-nil, tapping the link presents `destination(model)`;
    /// when the destination is popped, `model` is reset to nil.
    ///
    /// Built on `NavigationLink(isActive:)`, which is deprecated in iOS 16+. Prefer
    /// `NavigationLink(value:)` plus `.navigationDestination(for:)` on newer platforms.
    @available(*, deprecated, message: "Use `NavigationLink(value:)` plus `.navigationDestination(for:)` on iOS 16+.")
    public init<Model, _Destination: View>(
        model: Binding<Model?>,
        @ViewBuilder destination: (Model) -> _Destination,
        @ViewBuilder label: () -> Label
    ) where Destination == _Destination? {
        let isActive = Binding(
            get: { model.wrappedValue != nil },
            set: { value in
                if !value {
                    model.wrappedValue = nil
                }
            }
        )
        self.init(
            destination: model.wrappedValue.map(destination),
            isActive: isActive,
            label: label
        )
    }

}
