//
//  DeepLinkable+Receiver.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

extension DeepLinkable {

    public func firstReceiver<Receiver>(
        as type: Receiver.Type,
        where filter: (Receiver) -> Bool = { _ in true }
    ) -> Receiver! {
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
