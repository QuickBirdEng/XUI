//
//  View+Navigation.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension View {

    /// Wraps the view in a hidden `NavigationLink` that fires `action` when the user taps it.
    ///
    /// The link is never visually active — its `isActive` getter always returns `false` —
    /// it exists only to translate a tap into a side-effecting closure. Useful for
    /// coordinator-pattern flows where the parent decides what navigation should happen.
    @available(*, deprecated, message: "Use `NavigationLink(value:)` plus `.navigationDestination(for:)` on iOS 16+.")
    public func onNavigation(_ action: @escaping () -> Void) -> some View {
        let isActive = Binding(
            get: { false },
            set: { newValue in
                if newValue {
                    action()
                }
            }
        )
        return NavigationLink(
            destination: EmptyView(),
            isActive: isActive
        ) {
            self
        }
    }

    /// Convenience overload of `navigation(model:destination:)` that takes an
    /// `Identifiable` item binding.
    @available(*, deprecated, message: "Use `.navigationDestination(model:destination:)` on iOS 16+.")
    public func navigation<Item: Identifiable, Destination: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: (Item) -> Destination
    ) -> some View {

        navigation(model: item, destination: destination)
    }

    /// Pushes `destination(model)` onto the navigation stack when `model.wrappedValue` is
    /// non-nil; pops it (and resets the binding to nil) when navigation is dismissed.
    ///
    /// Implemented on top of `NavigationLink(isActive:)`, which is deprecated in iOS 16+.
    /// Prefer `navigationDestination(model:destination:)` on iOS 16 and later.
    @available(*, deprecated, message: "Use `.navigationDestination(model:destination:)` on iOS 16+.")
    public func navigation<Model, Destination: View>(
        model: Binding<Model?>,
        @ViewBuilder destination: (Model) -> Destination
    ) -> some View {
        let isActive = Binding(
            get: { model.wrappedValue != nil },
            set: { value in
                if !value {
                    model.wrappedValue = nil
                }
            }
        )
        return navigation(isActive: isActive) {
            model.wrappedValue.map(destination)
        }
    }

    /// Overlays a hidden `NavigationLink` that activates whenever `isActive` becomes `true`.
    @available(*, deprecated, message: "Use `.navigationDestination(isPresented:)` on iOS 16+.")
    public func navigation<Destination: View>(
        isActive: Binding<Bool>,
        @ViewBuilder destination: () -> Destination
    ) -> some View {

        overlay(
            NavigationLink(
                destination: isActive.wrappedValue ? destination() : nil,
                isActive: isActive,
                label: { EmptyView() }
            )
        )
    }

}
