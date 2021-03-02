//
//  DeepLinkable.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

public protocol DeepLinkable: AnyObject {
    @DeepLinkableBuilder var children: [DeepLinkable] { get }
}

extension DeepLinkable {

    @DeepLinkableBuilder
    public var children: [DeepLinkable] {
        get {}
    }

}
