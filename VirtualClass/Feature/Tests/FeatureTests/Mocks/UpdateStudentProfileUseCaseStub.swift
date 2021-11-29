//
//  UpdateStudentProfileUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK

final class UpdateStudentProfileUseCaseStub: UpdateStudentProfileUseCaseType {
    
    private let result: AnyPublisher<Void, StudentRepositoryError>
    
    init(result: AnyPublisher<Void, StudentRepositoryError>) {
        self.result = result
    }
    
    func update(_ profile: GenericUserProfile) -> AnyPublisher<Void, StudentRepositoryError> {
        result
    }
}
