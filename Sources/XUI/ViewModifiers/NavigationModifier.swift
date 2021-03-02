//
//  NavigationModifier.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

public struct NavigationModifier<Model, Destination: View>: ViewModifier {

    // MARK: Stored Properties

    private let model: Binding<Model?>
    private let destination: (Model) -> Destination

    // MARK: Initialization

    public init(model: Binding<Model?>,
                @ViewBuilder destination: @escaping (Model) -> Destination) {

        self.model = model
        self.destination = destination
    }

    // MARK: Methods

    public func body(content: Content) -> some View {
        content.navigation(model: model, destination: destination)
    }

}
