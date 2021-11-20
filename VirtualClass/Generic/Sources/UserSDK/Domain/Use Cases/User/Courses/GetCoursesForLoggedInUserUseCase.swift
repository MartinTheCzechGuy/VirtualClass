//
//  GetCoursesForLoggedInUserUseCase.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Foundation

public protocol GetCoursesForLoggedInUserUseCaseType {
    var courses: Result<Set<GenericCourse>, UserRepositoryError> { get }
}

final class GetCoursesForLoggedInUserUseCase {
    private let getCoursesUseCase: GetActiveCoursesUseCaseType
    private let getLogedInUserUseCase: GetLoggedInUserUseCaseType
    
    init(getCoursesUseCase: GetActiveCoursesUseCaseType, getLogedInUserUseCase: GetLoggedInUserUseCaseType) {
        self.getCoursesUseCase = getCoursesUseCase
        self.getLogedInUserUseCase = getLogedInUserUseCase
    }
}

extension GetCoursesForLoggedInUserUseCase: GetCoursesForLoggedInUserUseCaseType {
    var courses: Result<Set<GenericCourse>, UserRepositoryError> {
        guard let email = getLogedInUserUseCase.email else {
            return .failure(UserRepositoryError.storageError(nil))
        }
        
        return getCoursesUseCase.courses(forUser: email)
    }
}
