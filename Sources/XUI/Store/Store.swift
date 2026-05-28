//
//  Store.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

/// A SwiftUI property wrapper that observes a **protocol-typed** view model.
///
/// `@ObservedObject` requires the wrapped property to have a concrete `ObservableObject` type,
/// which prevents views from depending on a view-model protocol (e.g. for swapping in mocks
/// during previews or tests). `@Store` accepts any value that conforms to
/// `AnyObservableObject` — including a protocol existential — and re-publishes its
/// `objectWillChange` events to SwiftUI:
///
/// ```swift
/// struct RecipeListView: View {
///     @Store var viewModel: RecipeListViewModel   // a protocol
///     var body: some View {
///         List(viewModel.recipes, id: \.id) { recipe in
///             Text(recipe.title)
///         }
///     }
/// }
/// ```
///
/// Lifetime: like `@ObservedObject`, `@Store` does not own its model. The model must be held
/// by a longer-lived owner (a coordinator stored in a parent's `@StateObject`, an app-level
/// dependency container, etc.) — otherwise it will be deallocated when the view is recreated.
@propertyWrapper
public struct Store<Model>: DynamicProperty {

    // MARK: Nested types

    /// The `projectedValue` of `@Store`, vended as `$viewModel`. Uses `@dynamicMemberLookup`
    /// to produce a two-way `Binding` to any reference-writable key path on `Model`.
    @dynamicMemberLookup
    public struct Wrapper {

        fileprivate var store: Store

        /// Returns a two-way `Binding` to the given key path on the underlying model.
        public subscript<Value>(dynamicMember keyPath: ReferenceWritableKeyPath<Model, Value>) -> Binding<Value> {
            Binding(get: { self.store.wrappedValue[keyPath: keyPath] },
                    set: { self.store.wrappedValue[keyPath: keyPath] = $0 })
        }

    }

    // MARK: Stored properties

    /// The underlying model. Typically a protocol existential whose concrete implementation
    /// conforms to both the protocol and `AnyObservableObject`.
    public let wrappedValue: Model

    @ObservedObject
    private var observableObject: ErasedObservableObject

    // MARK: Computed Properties

    /// Returns a `Wrapper` exposing `Binding`s into the model via `@dynamicMemberLookup`.
    /// Accessed via `$viewModel` in a SwiftUI view.
    public var projectedValue: Wrapper {
        Wrapper(store: self)
    }

    // MARK: Initialization

    /// Wraps `wrappedValue` and subscribes to its `objectWillChange` publisher.
    ///
    /// `wrappedValue` **must** conform to `AnyObservableObject`. In debug builds, passing a
    /// value that does not conform raises an `assertionFailure`; in release builds the
    /// `Store` is still created but will not propagate any change notifications, so SwiftUI
    /// will not re-render the view when the model changes.
    public init(wrappedValue: Model) {
        self.wrappedValue = wrappedValue

        if let objectWillChange = (wrappedValue as? AnyObservableObject)?.objectWillChange {
            self.observableObject = .init(objectWillChange: objectWillChange.eraseToAnyPublisher())
        } else {
            assertionFailure("""
                @Store requires the wrapped value to conform to `AnyObservableObject`. \
                If the wrapped value is a class, conform it to `AnyObservableObject` — this is free \
                if it already conforms to `ObservableObject`. If it is a value type, use `@State` \
                or `@Binding` instead.
                """)
            self.observableObject = .empty()
        }
    }

    // MARK: Methods

    /// SwiftUI's `DynamicProperty` hook. Not intended to be called directly.
    public mutating func update() {
        _observableObject.update()
    }

}
