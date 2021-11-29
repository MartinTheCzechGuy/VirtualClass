//
//  AuthRepositoryType.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Combine

protocol AuthRepositoryType {
    func store(credentials: Credentials) -> Result<Void, AuthRepositoryError>
    func isExistingUser(withEmail email: String) -> AnyPublisher<Bool, AuthRepositoryError>
    var loggedInUserEmail: String? { get }
    func storedPassword(for email: String) -> Result<String?, AuthRepositoryError>
    func logout()
    func storeLoggedInUser(_ email: String)
}
