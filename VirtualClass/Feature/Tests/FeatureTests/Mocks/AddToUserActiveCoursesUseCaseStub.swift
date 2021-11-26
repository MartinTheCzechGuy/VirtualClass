//
//  AddToUserActiveCoursesUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK

final class AddToUserActiveCoursesUseCaseStub: AddToUserActiveCoursesUseCaseType {

    private let result: AnyPublisher<Void, UserRepositoryError>
    
    init(result: AnyPublisher<Void, UserRepositoryError>) {
        self.result = result
    }
    
    func add(idents: [String]) -> AnyPublisher<Void, UserRepositoryError> {
        result
    }
}
