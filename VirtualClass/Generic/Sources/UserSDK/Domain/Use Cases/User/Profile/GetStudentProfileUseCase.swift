//
//  GetStudentProfileUseCase.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Combine
import Common
import Foundation

public struct GetStudentProfileError: ErrorReportable {
    public enum ErrorCause: Error {
        case emailNotFound
        case profileNotFound(forEmail: String)
    }
    
    init(cause: ErrorCause, underlyingError: Error? = nil) {
        self.cause = cause
        self.underlyingError = underlyingError
    }
    
    public private(set) var cause: Error
    public private(set) var underlyingError: Error?
}

public protocol GetStudentProfileUseCaseType {
    var userProfile: AnyPublisher<GenericStudent?, GetStudentProfileError> { get }
}

final class GetStudentProfileUseCase {
    
    private let getLoggedInUserEmailUseCase: GetLoggedInUserUseCaseType
    private let userProfileRepository: StudentRepositoryType
    
    init(getLoggedInUserEmailUseCase: GetLoggedInUserUseCaseType, userProfileRepository: StudentRepositoryType) {
        self.userProfileRepository = userProfileRepository
        self.getLoggedInUserEmailUseCase = getLoggedInUserEmailUseCase
    }
}

extension GetStudentProfileUseCase: GetStudentProfileUseCaseType {
    var userProfile: AnyPublisher<GenericStudent?, GetStudentProfileError> {
        guard let email = getLoggedInUserEmailUseCase.email else {
            return Fail(error: GetStudentProfileError(cause: .emailNotFound))
                .eraseToAnyPublisher()
        }
        
        return userProfileRepository.load(userWithEmail: email)
            .mapError { GetStudentProfileError(cause: .profileNotFound(forEmail: email), underlyingError: $0) }
            .eraseToAnyPublisher()
    }
}
