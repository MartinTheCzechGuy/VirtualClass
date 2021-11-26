//
//  Teacher.swift
//  
//
//  Created by Martin on 21.11.2021.
//

import Foundation

public struct Teacher {
    public let id: UUID
    public let name: String
//    public let email: String
//    public private(set) var courses: Set<Course>
    
    public init(id: UUID, name: String
//         email: String
//         courses: Set<Course>
    ) {
        self.id = id
        self.name = name
//        self.email = email
//        self.courses = courses
    }
    
//    mutating func add(course: Course) {
//        if !courses.contains(course) {
//            courses.insert(course)
//        }
//    }
}

extension Teacher: Hashable {}
