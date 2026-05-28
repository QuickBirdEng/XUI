//
//  NavigationModifier.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

/// A coordinator-friendly `ViewModifier` that drives navigation off of a `Binding<Model?>`.
///
/// When `model.wrappedValue` is non-nil the destination is pushed; when it becomes nil
/// (either externally or via the back button) the navigation is dismissed. This isolates
/// transition logic in the coordinator and keeps leaf views unaware of how presentation
/// happens.
///
/// Built on `NavigationLink(isActive:)`, which is deprecated in iOS 16+. On those platforms
/// prefer `View.navigationDestination(model:destination:)`.
@available(*, deprecated, message: "Use `.navigationDestination(model:destination:)` on iOS 16+.")
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
