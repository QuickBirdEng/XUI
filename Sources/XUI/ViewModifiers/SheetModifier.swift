//
//  SheetModifier.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

public struct SheetModifier<Model, Destination: View>: ViewModifier {

    // MARK: Stored Properties

    private let model: Binding<Model?>
    private let destination: (Model) -> Destination

    // MARK: Initialization

    public init(model: Binding<Model?>,
                @ViewBuilder content: @escaping (Model) -> Destination) {

        self.model = model
        self.destination = content
    }

    // MARK: Methods

    public func body(content: Content) -> some View {
        content.sheet(model: model, content: destination)
    }

}
