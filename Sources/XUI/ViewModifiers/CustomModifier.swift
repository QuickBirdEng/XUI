//
//  NavigationModifier.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

public struct CustomModifier<Result: View>: ViewModifier {

    // MARK: Stored Properties

    private let _body: (Content) -> Result

    // MARK: Initialization

    public init(@ViewBuilder body: @escaping (Content) -> Result) {
        self._body = body
    }

    // MARK: Methods

    public func body(content: Content) -> some View {
        _body(content)
    }

}
