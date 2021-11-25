//
//  GetEventsUseCase.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Combine
import Common
import Foundation

public struct GetLecturesError: ErrorReportable {
    public enum ErrorCause: Error {
        case errorLoadingCourses
    }
    
    init(cause: ErrorCause, underlyingError: Error? = nil) {
        self.cause = cause
        self.underlyingError = underlyingError
    }
    
    public private(set) var cause: Error
    public private(set) var underlyingError: Error?
}


public protocol GetLecturesUseCaseType {
    func lectures(on: Date) -> AnyPublisher<[Lecture], GetLecturesError>
}

final class GetLecturesUseCase {
    private let coursesForLoggedInUserUseCase: GetCoursesForLoggedInUserUseCaseType
    
    init(coursesForLoggedInUserUseCase: GetCoursesForLoggedInUserUseCaseType) {
        self.coursesForLoggedInUserUseCase = coursesForLoggedInUserUseCase
    }
}

extension GetLecturesUseCase: GetLecturesUseCaseType {
    func lectures(on date: Date) -> AnyPublisher<[Lecture], GetLecturesError> {
        coursesForLoggedInUserUseCase.courses
            .mapError { GetLecturesError(cause: .errorLoadingCourses, underlyingError: $0) }
            .mapOptionalElement { filteredCourse -> Lecture? in
                guard let lessonOnDate = filteredCourse.lessons.first(where: { Calendar.current.isDate($0, inSameDayAs: date) }) else {
                    return nil
                }
                
                return Lecture(classIdent: filteredCourse.ident, className: filteredCourse.name, classRoomName: filteredCourse.classRoom.name, date: lessonOnDate)
                
            }
            .eraseToAnyPublisher()
    }
}
