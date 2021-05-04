//
//  File.swift
//  
//
//  Created by Paul Kraft on 04.05.21.
//

public typealias Pipeline<T> = AnyPublisher<T, Error>
public typealias Observable<T> = AnyPublisher<T, Never>

@resultBuilder
public struct Publish<Modifier: PublishModifier> {

    // MARK: Build

    public static func build<P: Publisher>(
        @Publish<Modifier> from build: () -> P
    ) -> P {
        build()
    }

    public static func build<Output>(
        @Publish<Modifier> from build: () throws -> AnyPublisher<Output, Error>
    ) -> AnyPublisher<Output, Error> {
        do {
            return try build()
        } catch {
            return Modifier.modify(Fail<Output, Error>(error: error))
        }
    }

    // MARK: Build Block

    public static func buildBlock<Output>(
        _ component: Output
    ) -> AnyPublisher<Output, Never> {
        Modifier.modify(Just(component))
    }

    public static func buildBlock<Output>(
        _ component: Output
    ) -> AnyPublisher<Output, Error> {
        Modifier.modify(Just(component).setFailureType(to: Error.self))
    }

    public static func buildBlock<P: Publisher>(
        _ component: P
    ) -> AnyPublisher<P.Output, Never> where P.Failure == Never {
        Modifier.modify(component)
    }

    public static func buildBlock<P: Publisher>(
        _ component: P
    ) -> AnyPublisher<P.Output, Error> where P.Failure == Never {
        Modifier.modify(component.setFailureType(to: Error.self))
    }

    public static func buildBlock<P: Publisher>(
        _ component: P
    ) -> AnyPublisher<P.Output, Error> {
        Modifier.modify(component.mapError { $0 as Error })
    }

    // MARK: Build Either

    public static func buildEither<P: Publisher>(first component: P) -> P {
        component
    }

    public static func buildEither<P: Publisher>(second component: P) -> P {
        component
    }

    // MARK: Build Limited Availability

    public static func buildLimitedAvailability<P: Publisher>(_ component: P) -> P {
        component
    }

}
