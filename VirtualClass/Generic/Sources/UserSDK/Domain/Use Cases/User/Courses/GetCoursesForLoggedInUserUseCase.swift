//
//  GetCoursesForLoggedInUserUseCase.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Combine
import Common
import Foundation

public struct GetCoursesForUserError: ErrorReportable {
    public enum ErrorCause: Error {
        case emailNotFound
        case errorLoadingCourses(forEmail: String)
    }
    
    init(cause: ErrorCause, underlyingError: Error? = nil) {
        self.cause = cause
        self.underlyingError = underlyingError
    }
    
    public private(set) var cause: Error
    public private(set) var underlyingError: Error?
}

public protocol GetCoursesForLoggedInUserUseCaseType {
    var courses: AnyPublisher<Set<GenericCourse>, GetCoursesForUserError> { get }
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
    var courses: AnyPublisher<Set<GenericCourse>, GetCoursesForUserError> {
        guard let email = getLogedInUserUseCase.email else {
            return Fail(error: GetCoursesForUserError(cause: .emailNotFound))
                .eraseToAnyPublisher()
        }
        
        return getCoursesUseCase.courses(forUserWithEmail: email)
            .mapError { GetCoursesForUserError(cause: .errorLoadingCourses(forEmail: email), underlyingError: $0) }
            .eraseToAnyPublisher()
    }
}
