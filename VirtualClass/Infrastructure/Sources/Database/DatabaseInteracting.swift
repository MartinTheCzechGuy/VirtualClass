//
//  DatabaseInteracting.swift
//  
//
//  Created by Martin on 21.11.2021.
//

import Combine
import Foundation

public protocol DatabaseInteracting {
    func create(domainModel: Student) -> AnyPublisher<Void, DatabaseError>

    func update(_ domainModel: UserProfile) -> AnyPublisher<Void, DatabaseError>

    func load(withID id: UUID) -> AnyPublisher<Student?, DatabaseError>
    func load(withEmail email: String) -> AnyPublisher<Student?, DatabaseError>
    func loadStudents() -> AnyPublisher<[Student], DatabaseError>
    func loadCourses() -> AnyPublisher<Set<Course>, DatabaseError>

    func delete(studentWithID id: UUID) -> AnyPublisher<Void, DatabaseError>
    
    func removeCourse(forUserWithEmail email: String, courseIdent ident: String) -> AnyPublisher<Void, DatabaseError>
    func markComplete(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, DatabaseError>
    func addCoursesAmongActive(idents: [String], forStudentWithEmail email: String) -> AnyPublisher<Void, DatabaseError>
}
