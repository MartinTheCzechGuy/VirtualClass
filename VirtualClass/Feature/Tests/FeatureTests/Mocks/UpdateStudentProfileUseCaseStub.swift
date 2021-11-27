//
//  UpdateStudentProfileUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK

final class UpdateStudentProfileUseCaseStub: UpdateStudentProfileUseCaseType {
    
    private let result: AnyPublisher<Void, UserRepositoryError>
    
    init(result: AnyPublisher<Void, UserRepositoryError>) {
        self.result = result
    }
    
    func update(_ profile: GenericUserProfile) -> AnyPublisher<Void, UserRepositoryError> {
        result
    }
}
