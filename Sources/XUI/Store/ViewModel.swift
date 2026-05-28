//
//  ViewModel.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

/// A composition of `AnyObservableObject` (for use with the `@Store` property wrapper) and
/// `DeepLinkable` (for `firstReceiver(as:where:)` lookup across a view-model hierarchy).
///
/// Most view-model protocols in an XUI-based app refine this:
///
/// ```swift
/// protocol RecipeListViewModel: ViewModel {
///     var recipes: [Recipe] { get }
///     func open(_ recipe: Recipe)
/// }
/// ```
///
/// Lifetime note: `@Store` observes its model with `@ObservedObject` semantics — it does
/// **not** own the model. Keep your root view models in a parent coordinator (or a
/// `@StateObject` wrapper) so they survive view re-creation.
public protocol ViewModel: AnyObservableObject, DeepLinkable {}
