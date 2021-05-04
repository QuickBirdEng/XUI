//
//  ErasedObservableObject.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

class ErasedObservableObject: ObservableObject {

    // MARK: Stored Properties

    let objectWillChange: AnyPublisher<Void, Never>

    // MARK: Initialization

    init(objectWillChange: AnyPublisher<Void, Never>) {
        self.objectWillChange = objectWillChange
    }

    // MARK: Factory Methods

    static func empty() -> ErasedObservableObject {
        .init(objectWillChange: Empty().eraseToAnyPublisher())
    }

}
