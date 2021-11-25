//
//  Student.swift
//  
//
//  Created by Martin on 21.11.2021.
//

import Foundation

public struct Student {
    public let id: UUID
    public let name: String
    public let email: String
    public private(set) var activeCourses: Set<Course>
    public private(set) var completedCourses: Set<Course>

    public init(
        id: UUID,
        name: String,
        email: String,
        activeCourses: Set<Course>,
        completedCourses: Set<Course>
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.activeCourses = activeCourses
        self.completedCourses = completedCourses
    }
    
    mutating func add(course: Course) {
        if !activeCourses.contains(course) {
            activeCourses.insert(course)
        }
    }
    
    mutating func complete(course: Course) {
        guard let removedCourse = activeCourses.remove(course) else {
            return
        }

        completedCourses.insert(removedCourse)
    }
}

extension Student: Identifiable {}

extension Student: Equatable {}

extension Student: Hashable {}
