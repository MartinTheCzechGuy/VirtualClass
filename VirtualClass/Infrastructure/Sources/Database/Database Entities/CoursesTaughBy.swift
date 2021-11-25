//
//  CoursesTaughtBy.swift
//  
//
//  Created by Martin on 18.11.2021.
//

import Foundation
import GRDB

struct CoursesTaughtBy: Codable, FetchableRecord, PersistableRecord {
    
    static var databaseTableName: String = DatabaseTable.coursesTaughtBy
    static let databaseUUIDEncodingStrategy: DatabaseUUIDEncodingStrategy = .uppercaseString
    
    var id: UUID
    var courseIdent: String
    var teacherId: UUID
    
    static let course = belongsTo(CourseEntity.self, key: "ident")
    static let teacher = belongsTo(TeacherEntity.self, key: "id")
}
