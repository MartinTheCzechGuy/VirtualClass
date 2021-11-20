//
//  GetCompletedCoursesUseCase.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import Foundation

public protocol GetCompletedCoursesUseCaseType {
    func courses(forUser email: String) -> Result<Set<GenericCourse>, UserRepositoryError>
}

final class GetCompletedCoursesUseCase {
    private let repository: StudentRepositoryType
    
    init(repository: StudentRepositoryType) {
        self.repository = repository
    }
}

extension GetCompletedCoursesUseCase: GetCompletedCoursesUseCaseType {
    func courses(forUser email: String) -> Result<Set<GenericCourse>, UserRepositoryError> {
        repository.load(userWithEmail: email)
            .map { optionalProfile in
                optionalProfile?.completedCourses ?? []
            }
    }
}
