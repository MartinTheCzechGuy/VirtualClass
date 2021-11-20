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

extension UserAuthRepository: UserAuthRepositoryType {
    
    func isExistingUser(withEmail email: String) -> Result<Bool, UserAuthRepositoryError> {
        database.load(withEmail: email)
            .map { optionalUser in
                optionalUser?.email != nil
            }
            .mapError(UserAuthRepositoryError.storageError)
    }
    
    var loggedInUserEmail: String? {
        keyValueLocalStorage.read(objectForKey: .userEmail)
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
    
    func storeLoggedInUser(_ email: String) {
        keyValueLocalStorage.set(email, for: .userEmail)
    }
    
    func logout() {
        keyValueLocalStorage.delete(objectForKey: .userEmail)
    }
}
