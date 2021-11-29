//
//  UserProfileRepositoryType.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Combine
import Foundation

protocol StudentRepositoryType {
    // Create new student entity
    func create(name: String, email: String) -> AnyPublisher<Void, StudentRepositoryError>
    // Update student entity
    func update(_ user: GenericUserProfile) -> AnyPublisher<Void, StudentRepositoryError>
    // Returns student with specified ID
    func load(userWithID id: UUID) -> AnyPublisher<GenericStudent?, StudentRepositoryError>
    // Returns student with specified email address
    func load(userWithEmail email: String) -> AnyPublisher<GenericStudent?, StudentRepositoryError>
    // Returns all students
    func loadAll() -> AnyPublisher<[GenericStudent], StudentRepositoryError>
    // Removes course from active ones for specified user
    func remove(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, StudentRepositoryError>
    // Marks a course as completed for specified user
    func markComplete(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, StudentRepositoryError>
    // Returns all currently active courses
    func activeCourses() -> AnyPublisher<Set<GenericCourse>, StudentRepositoryError>
    // Adds courses among students actives
    func addCourses(_ idents: [String], forStudentWithEmail email: String) -> AnyPublisher<Void, StudentRepositoryError>
}




