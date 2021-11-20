//
//  GetActiveCoursesUseCase.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Foundation

public protocol GetActiveCoursesUseCaseType {
    func courses(forUser email: String) -> Result<Set<GenericCourse>, UserRepositoryError>
}

final class GetActiveCoursesUseCase {
    private let repository: StudentRepositoryType
    
    init(repository: StudentRepositoryType) {
        self.repository = repository
    }
}

extension GetActiveCoursesUseCase: GetActiveCoursesUseCaseType {
    func courses(forUser email: String) -> Result<Set<GenericCourse>, UserRepositoryError> {
        repository.load(userWithEmail: email)
            .map { optionalProfile in
                optionalProfile?.activeCourses ?? []
            }
    }
}
