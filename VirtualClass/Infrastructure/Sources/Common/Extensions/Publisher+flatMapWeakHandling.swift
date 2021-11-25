//
//  Publisher+flatMapWeakHandling.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine

#warning("TODO - začít používat jakmile bude vše fungovat bez toho (nechci teď, aby vše nefungovalo kvůli tomuhle)")

extension Publisher {
    public func flatMap<A: AnyObject, Output>(
        weak obj: A,
        _ transform: @escaping (A, Self.Output) -> AnyPublisher<Output, Self.Failure>
    ) {
        flatMap { [weak obj] output -> AnyPublisher<Output, Failure> in
            guard let obj = obj else {
                return Empty(completeImmediately: true)
                    .handleEvents(
                        receiveCompletion: { _ in
                            print("🛑 Error - weak obj is nil!")
                        }
                    )
                    .eraseToAnyPublisher()
            }

            return transform(obj, output)
                .eraseToAnyPublisher()
        }
    }
}
