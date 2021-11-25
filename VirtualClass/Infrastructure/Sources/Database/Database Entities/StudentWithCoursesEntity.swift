//
//  StudentWithCoursesEntity.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import GRDB

// Helper struct just for fetching
struct StudentWithCoursesEntity: FetchableRecord, Decodable {
    var student: StudentEntity
    var activeCourses: [CompleteCourseEntity]
    var completedCourses: [CompleteCourseEntity]
}

