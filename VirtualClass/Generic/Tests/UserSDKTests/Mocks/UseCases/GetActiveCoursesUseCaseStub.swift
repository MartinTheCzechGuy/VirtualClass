//
//  GetActiveCoursesUseCaseStub.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine
@testable import UserSDK

final class GetActiveCoursesUseCaseStub: GetActiveCoursesUseCaseType {
    
    private let courses: AnyPublisher<Set<GenericCourse>, UserRepositoryError>
    
    init(courses: AnyPublisher<Set<GenericCourse>, UserRepositoryError>) {
        self.courses = courses
    }
    
    func courses(forUserWithEmail email: String) -> AnyPublisher<Set<GenericCourse>, UserRepositoryError> {
        courses
    }
}
