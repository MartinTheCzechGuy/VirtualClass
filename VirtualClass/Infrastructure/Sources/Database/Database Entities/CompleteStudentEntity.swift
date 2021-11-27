//
//  CompleteStudentEntity.swift
//  
//
//  Created by Martin on 27.11.2021.
//

import Foundation

struct CompleteStudentEntity {
    let id: UUID
    let name: String
    let email: String
    let activeCourses: [CompleteCourseEntity]
    let completedCourses: [CompleteCourseEntity]
}
