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
        var visited = Set<ObjectIdentifier>()
        var stack = [DeepLinkable]()
        return firstReceiver(
            where: { ($0 as? Receiver).map(filter) ?? false },
            visited: &visited,
            stack: &stack
        ) as? Receiver
    }

}

extension DeepLinkable {

    // MARK: Helpers - DeepLink

    private func firstReceiver(
        where filter: (Any) -> Bool,
        visited: inout Set<ObjectIdentifier>,
        stack: inout [DeepLinkable]
    ) -> Any? {

        visited.insert(ObjectIdentifier(self))

        guard !filter(self) else {
            return self
        }

        stack.append(
            contentsOf: children
                .filter { !visited.contains(ObjectIdentifier($0)) }
        )

        guard let next = stack.first else {
            return nil
        }

        stack.removeFirst()
        return next
            .firstReceiver(where: filter, visited: &visited, stack: &stack)
    }

}

