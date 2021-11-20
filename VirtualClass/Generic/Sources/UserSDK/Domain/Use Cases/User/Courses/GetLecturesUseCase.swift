//
//  GetEventsUseCase.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Combine
import Foundation
import UIKit

public protocol GetLecturesUseCaseType {
    func lectures(on: Date) -> Result<[Lecture], UserRepositoryError>
}

final class GetLecturesUseCase {
    private let coursesForLoggedInUserUseCase: GetCoursesForLoggedInUserUseCaseType
    
    init(coursesForLoggedInUserUseCase: GetCoursesForLoggedInUserUseCaseType) {
        self.coursesForLoggedInUserUseCase = coursesForLoggedInUserUseCase
    }
}

extension GetLecturesUseCase: GetLecturesUseCaseType {
    func lectures(on date: Date) -> Result<[Lecture], UserRepositoryError> {
        guard let courses = coursesForLoggedInUserUseCase.courses.success else {
            return .failure(UserRepositoryError.storageError(nil))
        }
        
        let lessons = courses
            .compactMap { filteredCourse -> Lecture? in
                guard let lessonOnDate = filteredCourse.lessons.first(where: { Calendar.current.isDate($0, inSameDayAs: date) }) else {
                    return nil
                }
                
                return Lecture(classIdent: filteredCourse.ident, className: filteredCourse.name, classRoomName: filteredCourse.classRoom.name, date: lessonOnDate)
            }
        
        return .success(lessons)
    }
}
