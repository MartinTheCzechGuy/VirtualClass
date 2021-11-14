//
//  File.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import BasicLocalStorage
import Combine
import Database
import SecureStorage

public enum UserAuthRepositoryError: Error {
    case storageError(Error?)
    case databaseError(Error?)
}

final class UserAuthRepository {

    private let database: UserDBRepositoryType
    private let keyValueLocalStorage: LocalKeyValueStorage
    private let secureStorage: SecureStorage
    
    init(
        database: UserDBRepositoryType,
        keyValueLocalStorage: LocalKeyValueStorage,
        secureStorage: SecureStorage
    ) {
        self.database = database
        self.keyValueLocalStorage = keyValueLocalStorage
        self.secureStorage = secureStorage
    }
}

extension UserAuthRepository: UserAuthRepositoryType {
    
    var isLoggedIn: Bool {
        keyValueLocalStorage.read(objectForKey: .userEmail) != nil
    }
    
    func store(credentials: Credentials) -> Result<Void, UserAuthRepositoryError> {
        keyValueLocalStorage.set(credentials.email, for: .userEmail)
        
        return secureStorage.setValue(credentials.password, for: credentials.email)
            .mapError(UserAuthRepositoryError.storageError)
    }
    
    func storedPassword(for email: String) -> Result<String?, UserAuthRepositoryError> {
        secureStorage.getValue(for: email)
            .mapError(UserAuthRepositoryError.storageError)
    }
    
    func logout() -> Result<Void, UserAuthRepositoryError> {
        keyValueLocalStorage.delete(objectForKey: .userEmail)
        
        return secureStorage.removeAllValues()
            .mapError(UserAuthRepositoryError.storageError)
    }
}
