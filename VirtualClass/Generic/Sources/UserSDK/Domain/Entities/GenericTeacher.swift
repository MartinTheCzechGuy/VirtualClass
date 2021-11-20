//
//  GenericTeacher.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Foundation

public struct GenericTeacher {
    public let id: UUID
    public let name: String
    public let email: String
//    public private(set) var courses: Set<GenericCourse>

    public init(
        id: UUID,
        name: String,
        email: String
//        courses: Set<GenericCourse>
    ) {
        self.id = id
        self.name = name
        self.email = email
//        self.courses = courses
    }
    
//    mutating func add(course: GenericCourse) {
//        if !courses.contains(course) {
//            courses.insert(course)
//        }
//    }
}

extension GenericTeacher: Hashable { }
