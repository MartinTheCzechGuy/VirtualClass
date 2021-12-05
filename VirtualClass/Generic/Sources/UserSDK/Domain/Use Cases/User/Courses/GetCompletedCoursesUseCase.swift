//
//  GetCompletedCoursesUseCase.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import Combine
import Foundation

protocol GetCompletedCoursesUseCaseType {
    func courses(userWithEmail email: String) -> AnyPublisher<Set<GenericCourse>, StudentRepositoryError>
}

final class GetCompletedCoursesUseCase {
    private let repository: StudentRepositoryType
    
    init(repository: StudentRepositoryType) {
        self.repository = repository
    }
}

extension GetCompletedCoursesUseCase: GetCompletedCoursesUseCaseType {
    func courses(userWithEmail email: String) -> AnyPublisher<Set<GenericCourse>, StudentRepositoryError> {
        repository.load(userWithEmail: email)
            .map { optionalProfile in
                optionalProfile?.completedCourses ?? []
            }
            .eraseToAnyPublisher()
    }
}
