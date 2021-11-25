//
//  FacultyEntity.swift
//  
//
//  Created by Martin on 17.11.2021.
//

import Foundation
import GRDB

enum FacultyEntityEnum: String, DatabaseValueConvertible, Codable {
    case facultyOfEconomics
    case facultyOfInformatics
    case facultyOfAccounting
    case facultyOfManagement
}

struct FacultyEntity: DatabaseQueryable {
    
    static var databaseTableName: String = DatabaseTable.faculty
    static let databaseUUIDEncodingStrategy: DatabaseUUIDEncodingStrategy = .uppercaseString
    
    var id: UUID
    var name: FacultyEntityEnum
    
    static let classes = hasMany(CourseEntity.self)
}
