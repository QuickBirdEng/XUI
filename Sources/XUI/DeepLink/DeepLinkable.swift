//
//  DeepLinkable.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

/// A node in a tree of coordinators / view models that can be searched by
/// `firstReceiver(as:where:)` for deep-linking purposes.
///
/// Conformers may expose their immediate children via the `children` property. If `children`
/// is not overridden, the default returns an empty array — in that case, `firstReceiver`
/// falls back to Mirror-based reflection over the conformer's stored properties to discover
/// nested `DeepLinkable`s automatically.
///
/// ```swift
/// final class AppCoordinator: ViewModel, ObservableObject {
///     @Published var recipes: RecipesCoordinator
///     @Published var settings: SettingsCoordinator?
///
///     var children: [DeepLinkable] {
///         recipes
///         if let settings { settings }
///     }
/// }
/// ```
///
/// The `children` property is built with `@DeepLinkableBuilder`, so `if`/`switch`/optional
/// syntax is supported.
public protocol DeepLinkable: AnyObject {

    /// The immediate children of this node, used to drive `firstReceiver(as:where:)` searches.
    ///
    /// Built via `@DeepLinkableBuilder`, supporting `if`/`switch`/optional inside the block.
    /// Defaults to an empty array; in that case `firstReceiver` falls back to Mirror
    /// reflection over stored properties.
    @DeepLinkableBuilder var children: [DeepLinkable] { get }
}

extension DeepLinkable {

    @DeepLinkableBuilder
    public var children: [DeepLinkable] {
        get {}
    }

}
