//
//  DeepLinkable.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

public protocol DeepLinkable: AnyObject {
    var children: [DeepLinkable] { get }
}

extension DeepLinkable {

    public var children: [DeepLinkable] {
        Mirror(reflecting: self)
            .values(extractDeepLinkable)
    }

    private func extractDeepLinkable(from object: Any) -> DeepLinkable? {
        if let value = object as? DeepLinkable {
            return value
        } else if let value = object as? DeepLinkableWrapper {
            return extractDeepLinkable(from: value.content)
        } else {
            return nil
        }
    }

}

extension Mirror {

    fileprivate func values<Value>(_ compactMap: (Any) -> Value?) -> [Value] {
        children.compactMap { compactMap($0.value) }
            + (superclassMirror?.values(compactMap) ?? [])
    }

}
