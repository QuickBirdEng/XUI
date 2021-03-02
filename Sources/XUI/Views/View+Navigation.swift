//
//  View+Navigation.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension View {

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

    public func navigation<Item: Identifiable, Destination: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: (Item) -> Destination
    ) -> some View {

        navigation(model: item, destination: destination)
    }

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
