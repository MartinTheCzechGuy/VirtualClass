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
    public let activeCourses: Set<GenericCourse>
    public let completedCourses: Set<GenericCourse>

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
}

extension GenericStudent: Hashable { }
