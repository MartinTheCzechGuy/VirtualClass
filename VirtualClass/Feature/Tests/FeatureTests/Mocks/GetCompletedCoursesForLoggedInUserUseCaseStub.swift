//
//  GetCompletedCoursesForLoggedInUserUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK

final class GetCompletedCoursesForLoggedInUserUseCaseStub: GetCompletedCoursesForLoggedInUserUseCaseType {
    
    private let coursesResult: AnyPublisher<Set<GenericCourse>, GetCompletedCoursesError>
    
    init(coursesResult: AnyPublisher<Set<GenericCourse>, GetCompletedCoursesError>) {
        self.coursesResult = coursesResult
    }
    
    var courses: AnyPublisher<Set<GenericCourse>, GetCompletedCoursesError> {
        coursesResult
    }
}
