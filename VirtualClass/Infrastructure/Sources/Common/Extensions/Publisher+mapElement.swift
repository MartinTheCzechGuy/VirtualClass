//
//  Publisher+mapElement.swift
//  
//
//  Created by Martin on 23.11.2021.
//

import Combine

public extension Publisher where Output: Sequence {
    func mapElement<NewOutput>(_ transform: @escaping (Output.Iterator.Element) -> NewOutput) -> AnyPublisher<[NewOutput], Failure> {
        map { $0.map(transform) }.eraseToAnyPublisher()
    }
    
    func mapOptionalElement<NewOutput>(_ transform: @escaping (Output.Iterator.Element) -> NewOutput?) -> AnyPublisher<[NewOutput], Failure> {
        map { $0.compactMap(transform) }.eraseToAnyPublisher()
    }
}
