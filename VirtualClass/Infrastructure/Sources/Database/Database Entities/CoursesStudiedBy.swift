//
//  CoursesStudiedBy.swift
//  
//
//  Created by Martin on 18.11.2021.
//

import Foundation
import GRDB

struct CoursesStudiedBy: Codable, FetchableRecord, PersistableRecord  {
    
    static var databaseTableName: String = DatabaseTable.coursesStudiedBy
    static let databaseUUIDEncodingStrategy: DatabaseUUIDEncodingStrategy = .uppercaseString
    
    var id: UUID
    var courseIdent: String
    var studentId: UUID
    
    static let course = belongsTo(CourseEntity.self)
    static let student = belongsTo(StudentEntity.self)
}
