//
//  AnyObservableObject.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

/// A non-generic counterpart to SwiftUI's `ObservableObject` that can be used as a
/// protocol existential.
///
/// SwiftUI's `ObservableObject` has an associated `ObjectWillChangePublisher` type, which
/// prevents it from being used as the type of a view's view-model property (you can't write
/// `var viewModel: any ObservableObject` and feed it to `@ObservedObject`). `AnyObservableObject`
/// fixes the publisher to `ObservableObjectPublisher`, which removes the associated-type
/// constraint and lets you abstract view models behind protocols.
///
/// Most conformers already inherit `ObservableObject` for the `@Published` machinery — in that
/// case, conforming to `AnyObservableObject` requires no additional code, because
/// `ObservableObject` synthesises a matching `objectWillChange` for free:
///
/// ```swift
/// protocol MyViewModel: AnyObservableObject {
///     var title: String { get set }
/// }
///
/// final class DefaultMyViewModel: MyViewModel, ObservableObject {
///     @Published var title: String = ""
/// }
/// ```
///
/// Used in combination with the `@Store` property wrapper to make view models protocol-typed.
public protocol AnyObservableObject: AnyObject {

    /// A publisher that emits before the object has changed.
    ///
    /// Conformers that already conform to `ObservableObject` get this for free — Swift
    /// synthesises an `ObservableObjectPublisher` from the `@Published` properties of the
    /// class.
    var objectWillChange: ObservableObjectPublisher { get }
}
