
![XUI Logo](README_Assets/Logo.jpeg)

![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)
![Platforms](https://img.shields.io/badge/platforms-iOS%2015%20%7C%20macOS%2012%20%7C%20watchOS%208%20%7C%20tvOS%2015-lightgrey.svg)
[![SwiftPM](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**XUI** lets your SwiftUI views depend on **view-model protocols** instead of concrete classes, and ships the tools you need to build a coordinator-pattern app around that — deep-link search across your view-model tree, model-driven sheet/popover/navigation modifiers, ergonomic `Binding` combinators, and a few Combine helpers.

```swift
struct RecipeListView: View {
    @Store var viewModel: RecipeListViewModel   // ← a protocol, not a concrete class
    var body: some View { /* ... */ }
}
```

Swap in a `DefaultRecipeListViewModel` for production, a `PreviewRecipeListViewModel` for `#Preview`, and a `MockRecipeListViewModel` for tests — all without touching the view.

## 🤔 Why XUI in 2026?

SwiftUI has evolved a lot since XUI shipped in 2021. Apple's Observation framework (`@Observable`, `@Bindable`, iOS 17+) and `NavigationStack` (iOS 16+) now cover some of what XUI originally provided. XUI is still useful when you want:

- **Protocol-typed view models.** `@Bindable` requires a concrete `@Observable` type — passing a protocol existential produces the compiler error `Referencing subscript 'subscript(dynamicMember:)' on 'Bindable' requires that 'any P' be a class type`. If you want your views to depend on a protocol with multiple production/preview/test implementations, `@Store` remains the most ergonomic path.
- **A coordinator-first architecture.** `DeepLinkable.firstReceiver(as:where:)` walks your view-model tree to resolve a deep link to a specific receiver. Pair it with the model-driven presentation modifiers (`navigation(model:)`, `sheet(model:)`, `popover(model:)`) and the parent coordinator owns the transition logic — leaf views stay unaware.
- **`Binding` ergonomics SwiftUI doesn't provide.** `Binding.first(where:)`, `Binding.ensure`, `Binding.willSet`/`didSet`, `Binding.map` — small, focused extensions that pay off across a real codebase.

On iOS 16+, prefer the new `navigationDestination(model:destination:)` to the deprecated `navigation(model:)`; on iOS 17+, `@Observable` types remain compatible with `@Store` as long as you also conform them to `AnyObservableObject`.

## 🛠 Installation

XUI is distributed via **Swift Package Manager**.

**In Xcode:** File → Add Package Dependencies… and paste `https://github.com/quickbirdstudios/XUI.git`. Select a version rule (we recommend "Up to Next Major") and add the `XUI` library to your target.

**In `Package.swift`:**

```swift
dependencies: [
    .package(url: "https://github.com/quickbirdstudios/XUI.git", from: "2.0.0"),
],
targets: [
    .target(name: "MyApp", dependencies: ["XUI"]),
]
```

Then `import XUI` in any file. XUI re-exports `SwiftUI`, `Combine`, and `Foundation`, so a single import covers most files.

**Requirements:** iOS 15+, macOS 12+, watchOS 8+, tvOS 15+, Swift 5.9+.

## 🏃‍♂️ Getting Started

### `@Store` — protocol-typed view models

First, declare your view-model protocol. Refine `ViewModel` (a composition of `AnyObservableObject` and `DeepLinkable`):

```swift
import XUI

protocol MyViewModel: ViewModel {
    var text: String { get set }
    func open()
}
```

Then provide an implementation. It must be a class. Conforming to `ObservableObject` automatically satisfies `AnyObservableObject` (Swift synthesises a matching `objectWillChange` from your `@Published` properties), so the machinery you already know just works:

```swift
import XUI

final class DefaultMyViewModel: MyViewModel, ObservableObject {
    @Published var text: String = ""

    func open() { /* … */ }
}
```

Finally, use the `@Store` property wrapper in your view, declaring the protocol — not the concrete class — as the property type:

```swift
import XUI

struct MyView: View {
    @Store var viewModel: MyViewModel

    var body: some View {
        TextField("Text", text: $viewModel.text)
    }
}
```

**Lifetime:** `@Store` has `@ObservedObject` semantics — it does **not** own the model. Hold root view models in a parent coordinator (or wrap them in a `@StateObject` at the top of your view hierarchy) so they survive view re-creation.

## 🧭 Coordinator Pattern

XUI's `Binding<Model?>`-driven modifiers and `DeepLinkable` tree work together to keep navigation logic in coordinators and out of leaf views.

```swift
final class AppCoordinator: ViewModel, ObservableObject {
    @Published var detail: DetailViewModel?
    @Published var settings: SettingsViewModel?
    @Published var recipes = RecipesCoordinator()

    var children: [DeepLinkable] {
        recipes
        if let detail { detail }
        if let settings { settings }
    }

    func open(_ recipe: Recipe) {
        detail = DetailViewModel(recipe: recipe)
    }
}
```

### Presentation: `navigation(model:)`, `sheet(model:)`, `popover(model:)`

Each modifier presents when its `Binding<Model?>` is non-nil and dismisses (resetting the binding to nil) when the user dismisses interactively:

```swift
struct RootView: View {
    @Store var viewModel: AppCoordinator

    var body: some View {
        NavigationStack {
            RecipesView(viewModel: viewModel.recipes)
                .sheet(model: $viewModel.settings) { vm in
                    SettingsView(viewModel: vm)
                }
                .navigationDestination(model: $viewModel.detail) { vm in
                    DetailView(viewModel: vm)
                }
        }
    }
}
```

On iOS 16+, prefer `navigationDestination(model:destination:)` over the deprecated `navigation(model:destination:)`. The `sheet(model:)` / `popover(model:)` modifiers identify the presented item by object identity, so `Model` should be a reference type (class or class-constrained protocol).

### Deep links: `firstReceiver(as:where:)`

`DeepLinkable.firstReceiver` does a breadth-first walk of the coordinator/view-model tree, falling back to Mirror reflection over stored properties if `children` doesn't yield a match. Use it to route an external URL or notification to the right receiver:

```swift
func handle(_ url: URL) {
    guard let id = url.recipeID,
          let detail = appCoordinator.firstReceiver(as: RecipeDetailViewModel.self, where: { $0.recipeID == id }) else {
        return
    }
    detail.focus()
}
```

## 🔁 Combine helpers

### `CancellableBuilder`

A result builder for storing multiple `Cancellable`s in a collection without writing `.store(in:)` at each call site. `if` / `switch` / `for` / `#available` are supported inside the block:

```swift
var cancellables = Set<AnyCancellable>()

cancellables.insert {
    viewModel.$title.sink { print("title:", $0) }
    viewModel.$count.sink { print("count:", $0) }

    if FeatureFlags.tracingEnabled {
        viewModel.$state.sink { tracer.record($0) }
    }
}
```

### `Result` interop (deprecated)

`asResult()`, `mapResult(success:failure:)`, and `tryMapResult(...)` bridge publisher errors into `Result` values. Deprecated in XUI 2.0 — prefer `async/await` with `do/try/catch`.

## 🧰 `Binding` combinators

### Validation

```swift
binding.ensure { !$0.isEmpty }   // silently drops writes that fail the predicate
binding.assert { !$0.isEmpty }   // asserts on read AND write (debug-only)
```

### Observation

```swift
binding.willSet { print("about to set:", $0) }
binding.didSet  { print("did set:",        $0) }
```

### Transformation

```swift
binding.map(get: { $0.uppercased() }, set: { $0.lowercased() })  // bidirectional
binding.alterGet { $0.uppercased() }  // read-side only
binding.alterSet { $0.lowercased() }  // write-side only
```

### Collection element bindings

```swift
var binding: Binding<[Recipe]>

binding.first(where: { $0.id == openedID })             // Binding<Recipe?>
binding.first(where: \.id, equals: openedID)            // Binding<Recipe?>
binding.first(equalTo: someRecipe)                      // Binding<Recipe?>

binding.first(equalTo: someRecipe).forceUnwrap()        // Binding<Recipe>   ⚠️ traps on nil
binding.first(equalTo: someRecipe).force(as: Any.self)  // Binding<Any>      ⚠️ traps on type mismatch
```

Write semantics for the `first(...)` family: setting a non-nil value when no element matches **appends** the value; setting a non-nil value when an element matches **replaces** it in place; setting `nil` **removes** the matching element.

## 📚 Example

A full sample app built with XUI lives at [SwiftUI-Coordinators-Example (`xui` branch)](https://github.com/quickbirdstudios/SwiftUI-Coordinators-Example/tree/xui).

## 🤝 Contributing

Issues and PRs welcome.

- Run tests with `swift test` from the repo root, or open `Package.swift` in Xcode and ⌘U.
- Please add a test for any new public API.
- For larger changes, open an issue first so we can align on design.

## 📃 License

XUI is released under an MIT license. See [LICENSE](LICENSE) for more information.

## 📖 Background reading

The design of XUI is explored in three QuickBird Studios blog posts:

- ["SwiftUI Architectures: Model-View, Redux & MVVM"](https://quickbirdstudios.com/blog/swiftui-architecture-redux-mvvm/)
- ["How to Use the Coordinator Pattern in SwiftUI"](https://quickbirdstudios.com/blog/coordinator-pattern-in-swiftui/)
- ["Handling Navigation in large SwiftUI projects"](https://quickbirdstudios.com/blog/swiftui-navigation-deep-links/)

## 👨‍💻 Author

Maintained by [QuickBird Studios](https://quickbirdstudios.com).
