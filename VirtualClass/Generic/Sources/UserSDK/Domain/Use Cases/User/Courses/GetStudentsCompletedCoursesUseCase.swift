//
//  GetStudentsCompletedCoursesUseCase.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import Foundation

public protocol GetCompletedCoursesForLoggedInUserUseCaseType {
    var courses: Result<Set<GenericCourse>, UserRepositoryError> { get }
}

final class GetCompletedCoursesForLoggedInUserUseCase {
    private let getCoursesUseCase: GetCompletedCoursesUseCaseType
    private let getLogedInUserUseCase: GetLoggedInUserUseCaseType
    
    init(getCoursesUseCase: GetCompletedCoursesUseCaseType, getLogedInUserUseCase: GetLoggedInUserUseCaseType) {
        self.getCoursesUseCase = getCoursesUseCase
        self.getLogedInUserUseCase = getLogedInUserUseCase
    }
}

extension GetCompletedCoursesForLoggedInUserUseCase: GetCompletedCoursesForLoggedInUserUseCaseType {
    var courses: Result<Set<GenericCourse>, UserRepositoryError> {
        guard let email = getLogedInUserUseCase.email else {
            return .failure(UserRepositoryError.storageError(nil))
        }
        
        return getCoursesUseCase.courses(forUser: email)
    }
}
