//
//  CourseEntity.swift
//  
//
//  Created by Martin on 17.11.2021.
//

import Foundation
import GRDB

struct CourseEntity: DatabaseQueryable {
    
    static var databaseTableName: String = DatabaseTable.course
    static let databaseUUIDEncodingStrategy: DatabaseUUIDEncodingStrategy = .uppercaseString
    
    var id: String {
        ident
    }
        
    var ident: String
    var name: String
    var description: String
    var credits: Int
    var lectures: [Date]
    var facultyId: UUID
    var classRoomId: UUID
    
    // MARK: - Relations
    
    static let taughtBy = hasMany(CoursesTaughtBy.self)
    static let teachers = hasMany(
        TeacherEntity.self,
        through: taughtBy,
        using: CoursesTaughtBy.teacher
    )
    
    static let studiedBy = hasMany(CoursesStudiedBy.self)
    static let students = hasMany(
        StudentEntity.self,
        through: studiedBy,
        using: CoursesStudiedBy.student
    )
    
    static let graduated = hasMany(CoursesCompletedBy.self)
    static let graduates = hasMany(
        StudentEntity.self,
        through: graduated,
        using: CoursesCompletedBy.student
    )
    
    static let faculty = belongsTo(FacultyEntity.self)
    static let classRoom = belongsTo(ClassRoomEntity.self)
}
