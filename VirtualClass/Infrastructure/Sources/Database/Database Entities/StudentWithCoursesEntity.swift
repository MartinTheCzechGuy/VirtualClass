//
//  StudentWithCoursesEntity.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Foundation
import GRDB

// Helper struct just for fetching
struct StudentWithCoursesEntity: FetchableRecord, Decodable {
    
    static func all() -> QueryInterfaceRequest<StudentWithCoursesEntity> {
        StudentEntity
            .including(all: StudentEntity.activeCourses.forKey(CodingKeys.activeCourses))
            .including(all: StudentEntity.completedCourses.forKey(CodingKeys.completedCourses))
            .asRequest(of: StudentWithCoursesEntity.self)
    }
    
    static func with(id: UUID) -> QueryInterfaceRequest<StudentWithCoursesEntity> {
        StudentEntity
            .filter(Column(StudentTableRow.id) == id.uuidString)
            .including(all: StudentEntity.activeCourses.forKey(CodingKeys.activeCourses))
            .including(all: StudentEntity.completedCourses.forKey(CodingKeys.completedCourses))
            .asRequest(of: StudentWithCoursesEntity.self)
    }
    
    static func with(email: String) -> QueryInterfaceRequest<StudentWithCoursesEntity> {
        StudentEntity
            .filter(Column(StudentTableRow.email) == email)
            .including(all: StudentEntity.activeCourses.forKey(CodingKeys.activeCourses))
            .including(all: StudentEntity.completedCourses.forKey(CodingKeys.completedCourses))
            .asRequest(of: StudentWithCoursesEntity.self)
    }
    
    var profile: StudentEntity
    var activeCourses: [CourseEntity]
    var completedCourses: [CourseEntity]
}


