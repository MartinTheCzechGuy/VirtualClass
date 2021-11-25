//
//  StudentEntity.swift
//  
//
//  Created by Martin on 17.11.2021.
//

import Foundation
import GRDB

struct StudentEntity: DatabaseQueryable {
    static var databaseTableName: String = DatabaseTable.student
    static var databaseUUIDEncodingStrategy: DatabaseUUIDEncodingStrategy = .uppercaseString
    
    var id: UUID
    var name: String
    var email: String
    
    static let studiedActiveCourses = hasMany(CoursesStudiedBy.self)
    static let activecourses = hasMany(
        CourseEntity.self,
        through: studiedActiveCourses,
        using: CoursesStudiedBy.course
    )
    
    static let studiedCompletedCourses = hasMany(CoursesStudiedBy.self)
    static let completedCourses = hasMany(
        CourseEntity.self,
        through: studiedCompletedCourses,
        using: CoursesStudiedBy.course
    )
}

