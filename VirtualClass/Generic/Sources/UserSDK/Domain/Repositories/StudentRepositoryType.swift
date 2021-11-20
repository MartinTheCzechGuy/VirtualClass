//
//  UserProfileRepositoryType.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Foundation

protocol StudentRepositoryType {
    // Create new student entity
    func create(name: String, email: String) -> Result<Void, UserRepositoryError>
    // Update student entity
    func update(_ user: GenericStudent) -> Result<Void, UserRepositoryError>
    // Returns student with specified ID
    func load(userWithID id: UUID) -> Result<GenericStudent?, UserRepositoryError>
    // Returns student with specified email address
    func load(userWithEmail email: String) -> Result<GenericStudent?, UserRepositoryError>
    // Returns all students
    func loadAll() -> Result<[GenericStudent], UserRepositoryError>
    // Returns all emails attached to any existing account
    func takenEmails() -> Result<[String], UserRepositoryError>
    // Removes course from active ones for specified user
    func remove(courseIdent ident: String, forUserWithEmail email: String) -> Result<Void, UserRepositoryError>
    // Marks a course as completed for specified user
    func markComplete(courseIdent ident: String, forUserWithEmail email: String) -> Result<Void, UserRepositoryError>
    // Returns all currently active courses
    func activeCourses() -> Result<Set<GenericCourse>, UserRepositoryError>
    // Adds courses among students actives
    func addCourses(_ idents: [String], forStudentWithEmail email: String) -> Result<Void, UserRepositoryError>
}




