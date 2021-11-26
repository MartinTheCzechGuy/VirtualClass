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
    var activeCourse: CourseEntity
    var activeClassRoom: ClassRoomEntity
    var activeFaculty: FacultyEntity
    var activeTeachers: [TeacherEntity]
    var activeStudents: [StudentEntity]
    var completedCourse: CourseEntity
    var completedClassRoom: ClassRoomEntity
    var completedFaculty: FacultyEntity
    var completedTeachers: [TeacherEntity]
    var completedStudents: [StudentEntity]
//    var activeCourses: [CompleteCourseEntity]
//    var completedCourses: [CompleteCourseEntity]
}

