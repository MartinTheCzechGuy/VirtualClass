//
//  UserProfileRepositoryType.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Foundation

protocol UserProfileRepositoryType {
    func update(_ user: UserProfile) -> Result<Void, UserRepositoryError>
    func load(userWithID id: UUID) -> Result<UserProfile?, UserRepositoryError>
    func load(userWithEmail email: String) -> Result<UserProfile?, UserRepositoryError>
    func loadAll() -> Result<[UserProfile], UserRepositoryError>
    func takenEmails() -> Result<[String], UserRepositoryError>
}




