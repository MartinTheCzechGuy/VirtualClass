//
//  GetCompletedCoursesUseCaseStub.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine
@testable import UserSDK

final class GetCompletedCoursesUseCaseStub: GetCompletedCoursesUseCaseType {
    
    private let courses: AnyPublisher<Set<GenericCourse>, UserRepositoryError>
    
    init(courses: AnyPublisher<Set<GenericCourse>, UserRepositoryError>) {
        self.courses = courses
    }
    
    func courses(userWithEmail email: String) -> AnyPublisher<Set<GenericCourse>, UserRepositoryError> {
        courses
    }
}
