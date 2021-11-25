//
//  RemoveCourseFromStudiedUseCase.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Combine

public protocol RemoveCourseFromStudiedUseCaseType {
    func remove(courseIdent ident: String) -> AnyPublisher<Void, UserRepositoryError>
}

final class RemoveCourseFromStudiedUseCase {
    private let studentRepository: StudentRepositoryType
    private let getLoggedInUserUseCase: GetLoggedInUserUseCaseType
    
    init(
        studentRepository: StudentRepositoryType,
        getLoggedInUserUseCase: GetLoggedInUserUseCaseType
    ) {
        self.studentRepository = studentRepository
        self.getLoggedInUserUseCase = getLoggedInUserUseCase
    }
}

extension RemoveCourseFromStudiedUseCase: RemoveCourseFromStudiedUseCaseType {
    func remove(courseIdent ident: String) -> AnyPublisher<Void, UserRepositoryError> {
        guard let email = getLoggedInUserUseCase.email else {
            return Fail(error: UserRepositoryError.storageError(nil)).eraseToAnyPublisher()
        }
        
        return studentRepository.remove(courseIdent: ident, forUserWithEmail: email)
    }
}
