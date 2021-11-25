//
//  CompleteCourseEntity.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import GRDB

// Helper struct just for fetching
struct CompleteCourseEntity: FetchableRecord, Decodable {
    var course: CourseEntity
    var classRoom: ClassRoomEntity
    var faculty: FacultyEntity
    var teachers: [TeacherEntity]
    var students: [StudentEntity]
}
