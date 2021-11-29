//
//  AddToUserActiveCoursesUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK

final class AddToUserActiveCoursesUseCaseStub: AddToUserActiveCoursesUseCaseType {

    private let result: AnyPublisher<Void, StudentRepositoryError>
    
    init(result: AnyPublisher<Void, StudentRepositoryError>) {
        self.result = result
    }
    
    func add(idents: [String]) -> AnyPublisher<Void, StudentRepositoryError> {
        result
    }
}
