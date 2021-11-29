//
//  MarkCourseCompleteUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK

final class MarkCourseCompleteUseCaseStub: MarkCourseCompleteUseCaseType {
    
    private let result: AnyPublisher<Void, StudentRepositoryError>

    init(result: AnyPublisher<Void, StudentRepositoryError>) {
        self.result = result
    }
    
    func complete(courseIdent ident: String) -> AnyPublisher<Void, StudentRepositoryError> {
        result
    }
}
