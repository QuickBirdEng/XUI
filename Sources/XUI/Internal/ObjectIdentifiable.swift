//
//  ObjectIdentifiable.swift
//  XUI
//
//  Created by Paul Kraft on 01.03.21.
//  Copyright © 2021 QuickBird Studios. All rights reserved.
//

struct ObjectIdentifiable: Identifiable {

    var id: ObjectIdentifier

    init(_ object: Any) {
        self.id = ObjectIdentifier(object as AnyObject)
    }

}
