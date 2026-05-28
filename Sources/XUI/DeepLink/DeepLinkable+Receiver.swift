//
//  DeepLinkable+Receiver.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension DeepLinkable {

    /// Searches the tree rooted at `self` for the first node of type `Receiver` that matches
    /// `filter`, returning it or `nil` if no match is found.
    ///
    /// The search is breadth-first over `children`, with cycle protection. If the search via
    /// `children` yields no match, a **second pass** uses Mirror reflection over each node's
    /// stored properties to discover any `DeepLinkable`-conforming fields that were not
    /// explicitly listed in `children`. This makes deep-link lookups work out of the box for
    /// types that haven't bothered to override `children`, at the cost of also reaching
    /// fields the author may not have intended to expose.
    ///
    /// - Parameters:
    ///   - type: The target type to search for (often a view-model protocol).
    ///   - filter: An optional predicate to further narrow the match. Defaults to accepting
    ///     any value of `Receiver`.
    /// - Returns: The first matching descendant, or `nil`.
    public func firstReceiver<Receiver>(
        as type: Receiver.Type,
        where filter: (Receiver) -> Bool = { _ in true }
    ) -> Receiver? {
        firstReceiver(ofType: type, where: filter) { $0.children }
            ?? firstReceiver(ofType: type, where: filter) {
                Mirror(reflecting: $0)
                    .values { $0 as? DeepLinkable }
            }
    }

}

extension DeepLinkable {

    // MARK: Helpers - DeepLink

    private func firstReceiver<Receiver>(
        ofType type: Receiver.Type,
        where filter: (Receiver) -> Bool,
        children: (DeepLinkable) -> [DeepLinkable]
    ) -> Receiver? {
        var visited = Set<ObjectIdentifier>()
        var stack = [DeepLinkable]()
        return firstReceiver(
            where: { ($0 as? Receiver).map(filter) ?? false },
            visited: &visited,
            stack: &stack,
            children: children
        ) as? Receiver
    }

    private func firstReceiver(
        where filter: (Any) -> Bool,
        visited: inout Set<ObjectIdentifier>,
        stack: inout [DeepLinkable],
        children: (DeepLinkable) -> [DeepLinkable]
    ) -> Any? {

        visited.insert(ObjectIdentifier(self))

        guard !filter(self) else {
            return self
        }

        stack.append(
            contentsOf: children(self)
                .filter { !visited.contains(ObjectIdentifier($0)) }
        )

        guard let next = stack.first else {
            return nil
        }

        stack.removeFirst()
        return next
            .firstReceiver(where: filter, visited: &visited, stack: &stack, children: children)
    }

}

extension Mirror {

    fileprivate func values<Value>(_ compactMap: (Any) -> Value?) -> [Value] {
        children.compactMap { compactMap($0.value) }
            + (superclassMirror?.values(compactMap) ?? [])
    }

}
