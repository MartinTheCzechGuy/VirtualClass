//
//  GenericStudent.swift
//  
//
//  Created by Martin on 19.11.2021.
//

import Foundation

public struct GenericStudent {
    public let id: UUID
    public let name: String
    public let email: String
    public private(set) var activeCourses: Set<GenericCourse>
    public private(set) var completedCourses: Set<GenericCourse>

    public init(
        id: UUID,
        name: String,
        email: String,
        activeCourses: Set<GenericCourse>,
        completedCourses: Set<GenericCourse>
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.activeCourses = activeCourses
        self.completedCourses = completedCourses
    }
    
    mutating func add(course: GenericCourse) {
        if !activeCourses.contains(course) {
            activeCourses.insert(course)
        }
    }
    
    mutating func complete(course: GenericCourse) {
        guard let removedCourse = activeCourses.remove(course) else {
            return
        }

        completedCourses.insert(removedCourse)
    }
}

extension GenericStudent: Hashable { }
