//
//  TeacherEntity.swift
//  
//
//  Created by Martin on 17.11.2021.
//

import Foundation
import GRDB

struct TeacherEntity: DatabaseQueryable {
    static var databaseTableName: String = DatabaseTable.teacher
    static var databaseUUIDEncodingStrategy: DatabaseUUIDEncodingStrategy = .uppercaseString
    
    var id: UUID
    var name: String

    static let lecturedCourses = hasMany(CoursesTaughtBy.self)
    static let courses = hasMany(
        CourseEntity.self,
        through: lecturedCourses,
        using: CoursesTaughtBy.course
    )
}
