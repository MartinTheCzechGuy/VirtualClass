//
//  MarkCourseCompleteUseCase.swift
//  
//
//  Created by Martin on 19.11.2021.
//

public protocol MarkCourseCompleteUseCaseType {
    func complete(courseIdent ident: String) -> Result<Void, UserRepositoryError>
}

final class MarkCourseCompleteUseCase {
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

extension MarkCourseCompleteUseCase: MarkCourseCompleteUseCaseType {
    func complete(courseIdent ident: String) -> Result<Void, UserRepositoryError> {
        guard let email = getLoggedInUserUseCase.email else {
            return .failure(UserRepositoryError.storageError(nil))
        }
        
        return studentRepository.markComplete(courseIdent: ident, forUserWithEmail: email)
    }
}
