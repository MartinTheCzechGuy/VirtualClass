//
//  Course.swift
//
//
//  Created by Martin on 17.11.2021.
//

import Foundation

public struct Course {
    public let ident: String
    public let name: String
    public let description: String
    public let credits: Int
    public let lessons: Set<Date>
    public let classRoom: ClassRoom
    public let faculty: Faculty
    public let teachers: Set<Teacher>
    public let students: Set<ClassMate>
    
    public init(
        ident: String,
        name: String,
        description: String,
        credits: Int,
        lessons: Set<Date>,
        classRoom: ClassRoom,
        faculty: Faculty,
        teachers: Set<Teacher>,
        students: Set<ClassMate>
    ) {
        self.ident = ident
        self.name = name
        self.description = description
        self.credits = credits
        self.lessons = lessons
        self.classRoom = classRoom
        self.faculty = faculty
        self.teachers = teachers
        self.students = students
    }
}

extension Course: Identifiable {
    public var id: String {
        ident
    }
}

extension Course: Equatable {}

extension Course: Hashable {}
