//
//  AddToUserActiveCoursesUseCase.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import Combine

public protocol AddToUserActiveCoursesUseCaseType {
    func add(idents: [String]) -> AnyPublisher<Void, StudentRepositoryError>
}

final class AddToUserActiveCoursesUseCase {
    private let studentRepository: StudentRepositoryType
    private let getLoggedInUserUseCase: GetLoggedInUserUseCaseType
    
    init(studentRepository: StudentRepositoryType, getLoggedInUserUseCase: GetLoggedInUserUseCaseType) {
        self.studentRepository = studentRepository
        self.getLoggedInUserUseCase = getLoggedInUserUseCase
    }
}

extension AddToUserActiveCoursesUseCase: AddToUserActiveCoursesUseCaseType {
    func add(idents: [String]) -> AnyPublisher<Void, StudentRepositoryError> {
        guard let email = getLoggedInUserUseCase.email else {
            return Fail(error: StudentRepositoryError.storageError(nil)).eraseToAnyPublisher()
        }
        
        return studentRepository.addCourses(idents, forStudentWithEmail: email)
    }
}
 
