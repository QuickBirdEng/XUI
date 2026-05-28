//
//  SheetModifier.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

/// A coordinator-friendly `ViewModifier` that drives a sheet presentation off of a
/// `Binding<Model?>`.
///
/// Non-nil `model` presents the sheet; setting `model` to nil (or the user dismissing the
/// sheet interactively) dismisses it. The model should be a reference type — XUI identifies
/// the presented item by object identity. The generic is unconstrained so that
/// class-constrained protocol existentials can be passed; see `View.sheet(model:destination:)`
/// for the detailed rationale.
public struct SheetModifier<Model, Destination: View>: ViewModifier {

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
        content.sheet(model: model, destination: destination)
    }

}
