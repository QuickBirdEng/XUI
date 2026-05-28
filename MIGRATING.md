# Migrating to XUI 2.0

XUI 2.0 raises the platform floor, fixes several API quirks that surfaced in long-term use, and modernises the codebase for Swift 5.9+. This guide enumerates every breaking change.

## Platform floor

| | 1.x | 2.0 |
|---|---|---|
| iOS | 13.0 | **15.0** |
| macOS | 10.15 | **12.0** |
| watchOS | 6.0 | **8.0** |
| tvOS | 13.0 | **15.0** |
| Swift tools | 5.3 | **5.9** |

If you cannot raise your deployment target, stay on XUI 1.x.

## `firstReceiver` returns `Receiver?` (was `Receiver!`)

The implicitly-unwrapped optional return type silently produced crashes at unexpected call sites. The signature is now an honest `Receiver?`.

**Before:**
```swift
let detail: DetailViewModel = root.firstReceiver(as: DetailViewModel.self)
detail.open()
```

**After:**
```swift
guard let detail = root.firstReceiver(as: DetailViewModel.self) else { return }
detail.open()
```

## `popover(model:)` / `sheet(model:)` argument label

The closure argument label is now `destination:` (was `content:`), matching `navigation(model:)`. The same rename applies to `PopoverModifier` and `SheetModifier`.

**Before:**
```swift
.sheet(model: $viewModel.modal, content: { vm in ModalView(viewModel: vm) })
.popover(model: $viewModel.popover, content: { vm in PopoverView(viewModel: vm) })
```

**After:**
```swift
.sheet(model: $viewModel.modal) { vm in ModalView(viewModel: vm) }
.popover(model: $viewModel.popover) { vm in PopoverView(viewModel: vm) }
```

## `sheet(model:)` / `popover(model:)` — value-type model footgun documented

Both modifiers identify the presented item by object identity. Passing a `struct`-typed `Model` silently re-boxes on every render (via `object as AnyObject`), producing a fresh `ObjectIdentifier` each time and causing the sheet/popover to re-present continuously. This was undocumented in 1.x; in 2.0 it's called out in the doc comments.

The constraint was **not** raised to `Model: AnyObject` because doing so would reject `any MyViewModel` even when `MyViewModel: AnyObject` (protocols don't self-conform to `AnyObject`), which would break the protocol-typed view model use case that is XUI's headline feature. The generic stays unconstrained; pass a reference type or a class-constrained protocol existential.

## `navigation(model:)` / `NavigationLink(model:)` / `onNavigation(_:)` / `NavigationModifier` are deprecated

These are built on `NavigationLink(isActive:)`, which Apple deprecated in iOS 16. They still function on iOS 15, but emit a deprecation warning.

**On iOS 16+, replace `.navigation(model:)` with `.navigationDestination(model:)`:**

```swift
// Before
ContentView()
    .navigation(model: $viewModel.detail) { vm in DetailView(viewModel: vm) }

// After
NavigationStack {
    ContentView()
        .navigationDestination(model: $viewModel.detail) { vm in DetailView(viewModel: vm) }
}
```

For `NavigationLink(model:destination:label:)`, prefer `NavigationLink(value:)` plus `.navigationDestination(for:)`.

## `Result+Combine` operators are deprecated

`Publisher.asResult()`, `Publisher.mapResult(success:failure:)`, and `Publisher.tryMapResult(...)` are deprecated. They will be removed in a future major release. Prefer structured concurrency:

```swift
// Before
publisher.tryMapResult(
    success: { $0.uppercased() },
    failure: { _ in "fallback" }
)

// After
do {
    let value = try await asyncCall()
    return value.uppercased()
} catch {
    return "fallback"
}
```

## Newly public `Binding.first(equalTo:)` / `Binding.first(as:)`

These overloads were documented in the README but accidentally non-public in 1.x. They are now `public` and available to callers.

## Internal cleanups

- `@_functionBuilder` was migrated to `@resultBuilder` (`CancellableBuilder`, `CollectionBuilder`). Both attributes are functionally equivalent — no caller change required.
- `Tests/LinuxMain.swift` and `Tests/XUITests/XCTestManifests.swift` were deleted (SwiftPM auto-discovers tests on Linux since 5.4).
