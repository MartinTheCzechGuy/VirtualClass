//
//  GetActiveCoursesForLoggedInUserUseCaseStub.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Combine
@testable import UserSDK

final class GetActiveCoursesForLoggedInUserUseCaseStub: GetActiveCoursesForLoggedInUserUseCaseType {
    
    private let coursesResult: AnyPublisher<Set<GenericCourse>, GetCoursesForUserError>
    
    init(coursesResult: AnyPublisher<Set<GenericCourse>, GetCoursesForUserError>) {
        self.coursesResult = coursesResult
    }
    
    var courses: AnyPublisher<Set<GenericCourse>, GetCoursesForUserError> {
        coursesResult
    }
}
