//
//  NavigationLink.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension NavigationLink {

    // MARK: Initialization

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
