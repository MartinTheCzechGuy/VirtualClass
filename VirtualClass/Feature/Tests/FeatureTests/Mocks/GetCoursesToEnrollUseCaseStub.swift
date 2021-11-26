//
//  GetCoursesToEnrollUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import Combine
import UserSDK

final class GetCoursesToEnrollUseCaseStub: GetCoursesToEnrollUseCaseType {
   
    private let coursesResult: AnyPublisher<Set<GenericCourse>, GetCoursesToEnrollError>
    
    init(coursesResult: AnyPublisher<Set<GenericCourse>, GetCoursesToEnrollError>) {
        self.coursesResult = coursesResult
    }
    
    func find(ident: String) -> AnyPublisher<Set<GenericCourse>, GetCoursesToEnrollError> {
        allAvailable
            .map { $0.filter { $0.ident == ident } }
            .eraseToAnyPublisher()
    }
    
    var allAvailable: AnyPublisher<Set<GenericCourse>, GetCoursesToEnrollError> {
        coursesResult
    }
}
