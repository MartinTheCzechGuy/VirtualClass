//
//  CreateStudentProfileUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
@testable import UserSDK

final class CreateStudentProfileUseCaseStub: CreateStudentProfileUseCaseType {
    
    private let result: AnyPublisher<Void, UserRepositoryError>
    
    init(result: AnyPublisher<Void, UserRepositoryError>) {
        self.result = result
    }
    
    func register(name: String, email: String) -> AnyPublisher<Void, UserRepositoryError> {
        result
    }
}
