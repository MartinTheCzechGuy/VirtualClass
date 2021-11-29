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
    public let activeCourses: Set<Course>
    public let completedCourses: Set<Course>

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
}

extension Student: Identifiable {}

extension Student: Equatable {}

extension Student: Hashable {}
