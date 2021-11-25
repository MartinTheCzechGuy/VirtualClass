//
//  GetActiveCoursesUseCase.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Combine
import Foundation

public protocol GetActiveCoursesUseCaseType {
    func courses(forUserWithEmail email: String) -> AnyPublisher<Set<GenericCourse>, UserRepositoryError>
}

final class GetActiveCoursesUseCase {
    private let repository: StudentRepositoryType
    
    init(repository: StudentRepositoryType) {
        self.repository = repository
    }
}

extension GetActiveCoursesUseCase: GetActiveCoursesUseCaseType {
    func courses(forUserWithEmail email: String) -> AnyPublisher<Set<GenericCourse>, UserRepositoryError> {
        repository.load(userWithEmail: email)
            .map { optionalProfile in
                optionalProfile?.activeCourses ?? []
            }
            .eraseToAnyPublisher()
    }
}
