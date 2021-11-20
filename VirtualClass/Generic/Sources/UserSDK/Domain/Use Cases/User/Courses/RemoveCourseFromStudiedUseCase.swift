//
//  RemoveCourseFromStudiedUseCase.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Foundation

public protocol RemoveCourseFromStudiedUseCaseType {
    func remove(courseIdent ident: String) -> Result<Void, UserRepositoryError>
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
    func remove(courseIdent ident: String) -> Result<Void, UserRepositoryError> {
        guard let email = getLoggedInUserUseCase.email else {
            return .failure(UserRepositoryError.storageError(nil))
        }
        
        return studentRepository.remove(courseIdent: ident, forUserWithEmail: email)
    }
}
