//
//  Tables+Rows.swift
//  
//
//  Created by Martin on 21.11.2021.
//

import Foundation

struct DatabaseTable {
    static let course = "course"
    static let completedCourse = "completedCourse"
    static let faculty = "faculty"
    static let user = "user"
    static let teacher = "teacher"
    static let student = "student"
    static let classRoom = "classroom"
    static let coursesTaughtBy = "coursesTaughtBy"
    static let coursesStudiedBy = "coursesStudiedBy"
    static let coursesCompletedBy = "coursesCompletedBy"
    
    static var tables: [String] = [
        course,
        faculty,
        user,
        teacher,
        student,
        classRoom
    ]
}

struct FacultyTableRow {
    static let id = "id"
    static let name = "name"
}

struct ClassRoomTableRow {
    static let id = "id"
    static let name = "name"
}

struct CourseTableRow {
    static let ident = "ident"
    static let name = "name"
    static let description = "description"
    static let credits = "credits"
    static let lectures = "lectures"
    static let classRoomId = "classRoomId"
    static let facultyId = "facultyId"
}

struct TeacherTableRow {
    static let id = "id"
    static let name = "name"
    static let email = "email"
}

struct StudentTableRow {
    static let id = "id"
    static let name = "name"
    static let email = "email"
}

struct CoursesStudiedByTableRow {
    static let id = "id"
    static let studentId = "studentId"
    static let courseId =  "courseIdent"
}

struct CoursesCompletedByTableRow {
    static let id = "id"
    static let studentId = "studentId"
    static let courseId =  "courseIdent"
}

struct CoursesTaughtByTableRow {
    static let id = "id"
    static let teacherId = "teacherId"
    static let courseId =  "courseIdent"
}
