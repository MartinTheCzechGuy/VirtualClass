//
//  GetCoursesToEnrollUseCase.swift
//  
//
//  Created by Martin on 20.11.2021.
//

import Combine
import Common

public struct GetCoursesToEnrollError: ErrorReportable {
    public enum ErrorCause: Error {
        case erorLoadingAvailableCourses
        case errorLoadingActiveCourses
    }
    
    public init(cause: ErrorCause, underlyingError: Error? = nil) {
        self.cause = cause
        self.underlyingError = underlyingError
    }
    
    public private(set) var cause: Error
    public private(set) var underlyingError: Error?
}

public protocol GetCoursesToEnrollUseCaseType {
    func find(ident: String) -> AnyPublisher<Set<GenericCourse>, GetCoursesToEnrollError>
    var allAvailable: AnyPublisher<Set<GenericCourse>, GetCoursesToEnrollError> { get }
}

final class GetCoursesToEnrollUseCase {
    private let studentRepository: StudentRepositoryType
    private let getCoursesForLoggedInUserUseCase: GetActiveCoursesForLoggedInUserUseCaseType
    
    init(studentRepository: StudentRepositoryType, getCoursesForLoggedInUserUseCase: GetActiveCoursesForLoggedInUserUseCaseType) {
        self.studentRepository = studentRepository
        self.getCoursesForLoggedInUserUseCase = getCoursesForLoggedInUserUseCase
    }
}

extension GetCoursesToEnrollUseCase: GetCoursesToEnrollUseCaseType {
    func find(ident: String) -> AnyPublisher<Set<GenericCourse>, GetCoursesToEnrollError> {
        allAvailable
            .map { $0.filter { $0.ident == ident } }
            .eraseToAnyPublisher()
    }
    
    var allAvailable: AnyPublisher<Set<GenericCourse>, GetCoursesToEnrollError> {
        studentRepository.activeCourses()
            .mapError { GetCoursesToEnrollError(cause: .erorLoadingAvailableCourses, underlyingError: $0) }
            .flatMap { [weak self] availableCourses -> AnyPublisher<Set<GenericCourse>, GetCoursesToEnrollError> in
                guard let self = self else {
                    return Fail(error: GetCoursesToEnrollError(cause: .errorLoadingActiveCourses, underlyingError: nil))
                        .eraseToAnyPublisher()
                }
                
                return self.getCoursesForLoggedInUserUseCase.courses
                    .mapError { .init(cause: .errorLoadingActiveCourses, underlyingError: $0) }
                    .map { enrolledCourses in
                        availableCourses.subtracting(enrolledCourses)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

