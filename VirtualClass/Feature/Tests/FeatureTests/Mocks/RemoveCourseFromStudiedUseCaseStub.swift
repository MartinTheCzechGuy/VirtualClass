//
//  RemoveCourseFromStudiedUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK

final class RemoveCourseFromStudiedUseCaseStub: RemoveCourseFromStudiedUseCaseType {
    
    private let result: AnyPublisher<Void, StudentRepositoryError>
    
    init(result: AnyPublisher<Void, StudentRepositoryError>) {
        self.result = result
    }
    
    func remove(courseIdent ident: String) -> AnyPublisher<Void, StudentRepositoryError> {
        result
    }
}
