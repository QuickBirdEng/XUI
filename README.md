
![XUI Logo](README_Assets/Logo.jpeg)

**X**UI is a toolbox for creating modular, reusable, testable app architectures with **SwiftUI**. With extensions to tackle common issues, **X**UI makes working with SwiftUI and Combine a lot easier!

* Easily keep your apps clean, maintainable and with a consistent app state 
* Abstract view models with protocols
* Make more use of common _SwiftUI_ and _Combine_ components
* Find any object in deep hierarchies

In our blog articles 
* ["SwiftUI Architectures: Model-View, Redux & MVVM"](https://quickbirdstudios.com/blog/swiftui-architecture-redux-mvvm/), 
* ["How to Use the Coordinator Pattern in SwiftUI"](https://quickbirdstudios.com/blog/coordinator-pattern-in-swiftui/) and 
* ["Handling Navigation in large SwiftUI projects"](https://quickbirdstudios.com/blog/swiftui-navigation-deep-links/),

we have already had a look at how to organize views and view models in SwiftUI. With all this knowledge, we have combined and summarized the most important and useful components in this library.

## 🔥 Features

- Abstraction of view models with protocols through the use of the `@Store` property wrapper
- Deep Linking made easy → simply find any coordinator or view model in your app with a single call!
- Useful extensions to make the use of SwiftUI and Combine simpler!

## 🏃‍♂️Getting Started

#### Store

One of the integral parts of **X**UI is the [`Store`](https://github.com/quickbirdstudios/XUI/blob/main/Sources/XUI/Store/Store.swift) property wrapper. It makes it possible to define SwiftUI view models with protocols.

Let me guide you through the process: First, we create a protocol for our view model and make that conform to `ViewModel`.

```swift
import XUI

protocol MyViewModel: ViewModel {

    // You can specify properties and methods as you like
    // This is just an example
    
    var text: String { get set }
    
    func open()
    
}
```

Secondly, we create an implementation for that protocol. Our implementation needs to be a class conforming to `ObservableObject` and our protocol.

```swift
import XUI

class DefaultMyViewModel: MyViewModel, ObservableObject {

    @Published var text: String
    
    func open() {
        // ...
    } 

}
```

Last but not least, we use the `Store` property wrapper to use a protocol as view model in our view.

```swift
import XUI

struct MyView: View {
    @Store var viewModel: MyViewModel
    
    var body: some View {
        TextField("Text", text: $viewModel.text)
    }
}
```

As you can see, you can use your view model as you would with the `@ObservedObject` property wrapper in SwiftUI. Instead of being constrained to a concrete type, you can specify a protocol instead. This way, we can write different implementations of the `MyViewModel` protocol and use them in `MyView` as well.

#### Deep Links

For deep links, we provide a search algorithm throughout your view model / coordinator hierarchy. You can use the `DeepLinkable` protocol to provide access to your immediate children. To find a specific child in that hierarchy, you can use the `firstReceiver` method on `DeepLinkable`.

You can find a more extensive explanation in [this blog article](https://quickbirdstudios.com/blog/swiftui-navigation-deep-links/).

## 🤸‍♂️ Extensions

**X**UI makes working with Combine and SwiftUI a lot easier!

#### Cancellable

When working with Combine extensively, there might be many occurences of `.store(in: &cancellables)` in your code. To minimize code size and make code a bit more readable, we offer a function builder to insert multiple `Cancellables` in a collection at once. Let's see it in action:

```swift
var cancellables = Set<AnyCancellable>()

cancellables.insert {
    $myViewModel.title
        .sink { print("MyViewModel title changed to", $0) }

    $myViewModel.text
        .sink { print("MyViewModel text changed to", $0) }
}
```

#### Publisher

With Publishers, you often work with singles or simply publishers that will only emit a single value or an error. To make working with these publishers easier (and since the `Result` type is part of Swift now), we can simply build the following extensions:

```swift
var publisher: AnyPublisher<String, MyError>

publisher.asResult() // AnyPublisher<Result<String, MyError>, Never>
publisher.mapResult(success: { $0 }, failure: { _ in "Error occured." }) // AnyPublisher<String, Never>
publisher.tryMapResult(success: { $0 }, failure: { throw $0 }) // AnyPublisher<String, Error>

```

#### ViewModifiers

When using the Coordinator Pattern in SwiftUI (as discussed in [this blog article](https://quickbirdstudios.com/blog/coordinator-pattern-in-swiftui/)), we need to inject a view modifier into a child view, so that transition logic is fully specified by the coordinator view rather than being distributed across views.

`NavigationModifier`, `PopoverModifier` and `SheetModifier` are provided, with a similar interface to the actual modifiers.

#### View

To make working with `NavigationView` simpler in SwiftUI, we provide a `onNavigation` method that can be used, when you would like a closure to be performed, when a `NavigationLink` is performed. Simply put it around your view, it will add a `NavigationLink` itself.

Further, we add methods to your views for handling `sheet`, `popover` and `navigation` with view model protocols.

Example:

```swift
struct MyView: View {
    
    @Store var viewModel: MyViewModel
    
    var body: some View {
        NavigationView {
            Text("Example")
                .navigation(model: $viewModel.detailViewModel) { viewModel in
                    DetailView(viewModel: viewModel)
                }
                .sheet(model: $viewModel.sheetViewModel) { viewModel in
                    SheetView(viewModel: viewModel)
                }
        }
    }
    
}
```

#### Binding

Working with bindings, especially when it concerns collections is hard - but no longer! We have written a few extensions to easily work with elements of collections using bindings. 

```swift
var binding: Binding<[String]>

binding.first(equalTo: "example") // Binding<String?>
binding.first(where: { $0.count < 5 }) // Binding<String?>, this is not a practical example though

binding.first(equalTo: "example").forceUnwrap() // Binding<String>
binding.first(equalTo: "example").force(as: CustomStringConvertible.self) // Binding<CustomStringConvertible>

```

Further, one would possibly like to alter or observe the values being used through a binding.

```swift
var binding: Binding<String>

binding.willSet { print("will set", $0) } 
// Binding<String>, will print whenever a new value is set by the binding, before it is forwarded to the initial binding

binding.didSet { print("did set", $0) } 
// Binding<String>, will print whenever a new value is set by the binding, after it is forwarded to the initial binding

binding.ensure { !$0.isEmpty }
// Binding<String>, will only set the initial binding, when the condition is fulfilled

binding.assert { !$0.isEmpty }
// Binding<String>, will assert on get and set, that a condition is fulfilled

binding.map(get: { $0.first! }, set: { String($0) })
// Binding<String>, will map the binding's value to a different type

binding.alterGet { $0.prefix(1) } 
// Binding<String>, will forward the altered value on get

binding.alterSet { $0.prefix(1) } 
// Binding<String>, will forward the altered value on set to the underlying binding
```

## 📚 Example

As an example on how to use **X**UI in your application, we have written a [Recipes App](https://github.com/quickbirdstudios/SwiftUI-Coordinators-Example/tree/xui) with the help of **X**UI.

## 🛠 Installation

#### Swift Package Manager

See [this WWDC presentation](https://developer.apple.com/videos/play/wwdc2019/408/) about more information how to use Swift packages in your app.
Specify `https://github.com/quickbirdstudios/XUI.git` as the `XUI` package link.

## 👨‍💻 Author

This framework is created with ❤️ by [QuickBird Studios](https://quickbirdstudios.com).

## 🤝 Contributing

Open an issue if you need help, if you found a bug, or if you want to discuss a feature request.
Open a PR if you want to make changes to **X**UI.

## 📃 License

**X**UI is released under an MIT license. See [License.md](https://github.com/quickbirdstudios/XUI/blob/master/LICENSE) for more information.
