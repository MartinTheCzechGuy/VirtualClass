//
//  GetLecturesUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import Foundation
import UserSDK

final class GetLecturesUseCaseStub: GetLecturesUseCaseType {
    
    private let result: AnyPublisher<[Lecture], GetLecturesError>
    
    init(result: AnyPublisher<[Lecture], GetLecturesError>) {
        self.result = result
    }
    
    func lectures(on: Date) -> AnyPublisher<[Lecture], GetLecturesError> {
        result
    }
}
