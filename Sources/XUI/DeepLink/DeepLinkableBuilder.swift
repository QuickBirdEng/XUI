//
//  DeepLinkableBuilder.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

public typealias DeepLinkableBuilder = CollectionBuilder<DeepLinkable>

@_functionBuilder
public struct CollectionBuilder<Component> {

    public static func buildBlock(_ components: [Component]...) -> [Component] {
        components.flatMap { $0 }
    }

    public static func buildBlock() -> [Component] {
        []
    }

    public static func buildExpression(_ expression: Component) -> [Component] {
        [expression]
    }

    public static func buildExpression(_ expression: Component?) -> [Component] {
        [expression].compactMap { $0 }
    }

    public static func buildExpression(_ expression: Void) -> [Component] {
        []
    }

    public static func buildOptional(_ component: [Component]?) -> [Component] {
        component ?? []
    }

    public static func buildEither(first component: Component) -> [Component] {
        [component]
    }

    public static func buildEither(second component: Component) -> [Component] {
        [component]
    }

    public static func buildEither(first component: [Component]) -> [Component] {
        component
    }

    public static func buildEither(second component: [Component]) -> [Component] {
        component
    }

    public static func buildArray(_ components: [Component]) -> [Component] {
        components
    }

    public static func buildLimitedAvailability(_ component: [Component]) -> [Component] {
        component
    }

    public static func buildFinalResult(_ component: [Component]) -> [Component] {
        component
    }

}
