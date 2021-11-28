//
//  CompleteCourseEntity.swift
//  
//
//  Created by Martin on 25.11.2021.
//

import Foundation
import GRDB

// Helper struct just for fetching
struct CompleteCourseEntity: FetchableRecord, Decodable {
    
    static func all() -> QueryInterfaceRequest<CompleteCourseEntity> {
        CourseEntity        
            .including(all: CourseEntity.teachers.forKey(CodingKeys.teachers))
            .including(all: CourseEntity.students.forKey(CodingKeys.students))
            .including(required: CourseEntity.faculty.forKey(CodingKeys.faculty))
            .including(required: CourseEntity.classRoom.forKey(CodingKeys.classRoom))
            .asRequest(of: CompleteCourseEntity.self)
    }
    
    static func forStudent(withEmail email: String) -> QueryInterfaceRequest<CompleteCourseEntity> {
        let student = CourseEntity.students.filter(Column("email") == email)
        
        return CourseEntity
            .joining(required: student)
            .including(all: CourseEntity.teachers.forKey(CodingKeys.teachers))
            .including(all: CourseEntity.students.forKey(CodingKeys.students))
            .including(required: CourseEntity.faculty.forKey(CodingKeys.faculty))
            .including(required: CourseEntity.classRoom.forKey(CodingKeys.classRoom))
            .asRequest(of: CompleteCourseEntity.self)
    }
    
    static func with(ident: String) -> QueryInterfaceRequest<CompleteCourseEntity> {
        CourseEntity
            .filter(id: ident)
            .including(all: CourseEntity.teachers.forKey(CodingKeys.teachers))
            .including(all: CourseEntity.students.forKey(CodingKeys.students))
            .including(required: CourseEntity.faculty.forKey(CodingKeys.faculty))
            .including(required: CourseEntity.classRoom.forKey(CodingKeys.classRoom))
            .asRequest(of: CompleteCourseEntity.self)
    }
    
    var course: CourseEntity
    var classRoom: ClassRoomEntity
    var faculty: FacultyEntity
    var teachers: [TeacherEntity]
    var students: [StudentEntity]
}
