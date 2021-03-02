//
//  View+Popover.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension View {

    public func popover<Model, Content: View>(
        model: Binding<Model?>,
        @ViewBuilder content: @escaping (Model) -> Content
    ) -> some View {

        popover(item: model.objectIdentifiable()) { _ in
            model.wrappedValue.map(content)
        }
    }

}
