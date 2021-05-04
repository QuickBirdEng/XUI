//
//  File.swift
//  
//
//  Created by Paul Kraft on 04.05.21.
//

public protocol PublishModifier {
    static func modify<P: Publisher>(_ publisher: P) -> AnyPublisher<P.Output, P.Failure>
}

public struct MainQueue: PublishModifier {

    public static func modify<P: Publisher>(
        _ publisher: P
    ) -> AnyPublisher<P.Output, P.Failure> {
        publisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

extension Never: PublishModifier {

    public static func modify<P: Publisher>(
        _ publisher: P
    ) -> AnyPublisher<P.Output, P.Failure> {
        publisher
            .eraseToAnyPublisher()
    }

}
