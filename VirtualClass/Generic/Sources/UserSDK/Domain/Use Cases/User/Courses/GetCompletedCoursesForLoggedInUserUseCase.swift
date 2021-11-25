//
//  GetCompletedCoursesForLoggedInUserUseCase.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import Combine
import Common

public struct GetCompletedCoursesError: ErrorReportable {
    public enum ErrorCause: Error {
        case missingEmail
        case errorLoadingCourses
    }
    
    init(cause: ErrorCause, underlyingError: Error? = nil) {
        self.cause = cause
        self.underlyingError = underlyingError
    }
    
    public private(set) var cause: Error
    public private(set) var underlyingError: Error?
}

public protocol GetCompletedCoursesForLoggedInUserUseCaseType {
    var courses: AnyPublisher<Set<GenericCourse>, GetCompletedCoursesError> { get }
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
    var courses: AnyPublisher<Set<GenericCourse>, GetCompletedCoursesError> {
        guard let email = getLogedInUserUseCase.email else {
            return Fail(error: GetCompletedCoursesError(cause: .missingEmail))
                .eraseToAnyPublisher()
        }
        
        return getCoursesUseCase.courses(userWithEmail: email)
            .mapError {  GetCompletedCoursesError(cause: .errorLoadingCourses, underlyingError: $0) }
            .eraseToAnyPublisher()
    }
}
