//
//  GenericCourse.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Foundation

public struct GenericCourse {
    public let ident: String
    public let name: String
    public let description: String
    public let credits: Int
    public let lessons: Set<Date>
    public let classRoom: GenericClassRoom
    public let faculty: GenericFaculty
    public let teachers: Set<GenericTeacher>
//    public let students: Set<GenericStudent>
    
    public init(
        ident: String,
        name: String,
        description: String,
        credits: Int,
        lessons: Set<Date>,
        classRoom: GenericClassRoom,
        faculty: GenericFaculty,
        teachers: Set<GenericTeacher>
//        students: Set<GenericStudent>
    ) {
        self.ident = ident
        self.name = name
        self.description = description
        self.credits = credits
        self.lessons = lessons
        self.classRoom = classRoom
        self.faculty = faculty
        self.teachers = teachers
//        self.students = students
    }
}

extension GenericCourse: Hashable {}

extension GenericCourse: Identifiable {
    public var id: String {
        ident
    }
}
