//
//  UserProfileRepository.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import BasicLocalStorage
import Combine
import Database
import Foundation
import SecureStorage

public enum UserRepositoryError: Error {
    case storageError(Error?)
    case databaseError(Error?)
}

final class UserProfileRepository {
    
    private let database: StudentDBRepositoryType
    private let keyValueLocalStorage: LocalKeyValueStorage
    private let secureStorage: SecureStorage
    
    init(
        database: StudentDBRepositoryType,
        keyValueLocalStorage: LocalKeyValueStorage,
        secureStorage: SecureStorage
    ) {
        self.database = database
        self.keyValueLocalStorage = keyValueLocalStorage
        self.secureStorage = secureStorage
    }
}

extension UserProfileRepository: UserProfileRepositoryType {
    
    func create(name: String, email: String) -> Result<Void, UserRepositoryError> {
        database.create(domainModel: Student(id: UUID(), name: name, email: email, courses: []))
            .mapError(UserRepositoryError.databaseError)
    }
    
    func update(_ user: UserProfile) -> Result<Void, UserRepositoryError> {
        var classes = Set<Course>()
        user.classes.forEach { classes.insert(
            Course(
                ident: $0.ident,
                name: $0.name,
                events: [],
                classRoom: .init(id: UUID(), name: "tada"),
                faculty: .facultyOne,
                teachers: [],
                students: [])
        )
        }
        
        return database.update(
            Student(
                id: user.id,
                name: user.name,
                email: user.email,
                courses: []
            )
        )
            .mapError(UserRepositoryError.databaseError)
    }
    
    func load(userWithID id: UUID) -> Result<UserProfile?, UserRepositoryError> {
        database.load(withID: id)
            .mapUserToDomain()
            .mapError(UserRepositoryError.databaseError)
    }
    
    func load(userWithEmail email: String) -> Result<UserProfile?, UserRepositoryError> {
        database.load(withEmail: email)
            .mapUserToDomain()
            .mapError(UserRepositoryError.databaseError)
    }
    
    func loadAll() -> Result<[UserProfile], UserRepositoryError> {
        database.loadAll()
            .mapUsersToDomain()
            .mapError(UserRepositoryError.databaseError)
    }
    
    func takenEmails() -> Result<[String], UserRepositoryError> {
        database.loadAll()
            .mapError(UserRepositoryError.databaseError)
            .map { usersArray -> [String] in
                usersArray.map { $0.email }
            }
    }
}

extension Result where Success == Student? {
    func mapUserToDomain() -> Result<UserProfile?, Failure> {
        map { domainModel in
            guard let domainModel = domainModel else {
                return nil
            }
            
            var classes = Set<Class>()
            //            domainModel.classes.forEach { classes.insert(Class(id: $0.id, name: $0.name)) }
            
            return UserProfile(
                id: domainModel.id,
                name: domainModel.name,
                email: domainModel.email,
                classes: classes
            )
        }
    }
}

extension Result where Success == [Student] {
    func mapUsersToDomain() -> Result<[UserProfile], Failure> {
        map {
            $0.map {
                var classes = Set<Class>()
                //                $0.classes.forEach { classes.insert(Class(id: $0.id, name: $0.name)) }
                
                return UserProfile(id: $0.id, name: $0.name, email: $0.email, classes: classes)
            }
        }
    }
}