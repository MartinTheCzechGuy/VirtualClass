//
//  ClassRoomEntity.swift
//  
//
//  Created by Martin on 17.11.2021.
//

import Foundation
import GRDB

struct ClassRoomEntity: DatabaseQueryable {
        
    static var databaseTableName: String = DatabaseTable.classRoom
    static let databaseUUIDEncodingStrategy: DatabaseUUIDEncodingStrategy = .uppercaseString
    
    var id: UUID
    var name: String
    
    static let classes = hasMany(CourseEntity.self)
}
