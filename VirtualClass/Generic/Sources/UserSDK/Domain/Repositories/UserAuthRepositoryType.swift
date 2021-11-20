//
//  UserAuthRepositoryType.swift
//  
//
//  Created by Martin on 13.11.2021.
//

protocol UserAuthRepositoryType {
    func store(credentials: Credentials) -> Result<Void, UserAuthRepositoryError>
    func isExistingUser(withEmail email: String) -> Result<Bool, UserAuthRepositoryError>
    var loggedInUserEmail: String? { get }
    func storedPassword(for email: String) -> Result<String?, UserAuthRepositoryError>
    func logout()
    func storeLoggedInUser(_ email: String)
}
