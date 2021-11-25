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
    func create(name: String, email: String) -> AnyPublisher<Void, UserRepositoryError>
    // Update student entity
    func update(_ user: GenericStudent) -> AnyPublisher<Void, UserRepositoryError>
    // Returns student with specified ID
    func load(userWithID id: UUID) -> AnyPublisher<GenericStudent?, UserRepositoryError>
    // Returns student with specified email address
    func load(userWithEmail email: String) -> AnyPublisher<GenericStudent?, UserRepositoryError>
    // Returns all students
    func loadAll() -> AnyPublisher<[GenericStudent], UserRepositoryError>
    // Removes course from active ones for specified user
    func remove(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, UserRepositoryError>
    // Marks a course as completed for specified user
    func markComplete(courseIdent ident: String, forUserWithEmail email: String) -> AnyPublisher<Void, UserRepositoryError>
    // Returns all currently active courses
    func activeCourses() -> AnyPublisher<Set<GenericCourse>, UserRepositoryError>
    // Adds courses among students actives
    func addCourses(_ idents: [String], forStudentWithEmail email: String) -> AnyPublisher<Void, UserRepositoryError>
}




