//
//  AuthRepository.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import BasicLocalStorage
import Combine
import Database
import SecureStorage

public enum AuthRepositoryError: Error {
    case storageError(Error?)
    case databaseError(Error?)
}

final class AuthRepository {

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

extension AuthRepository: AuthRepositoryType {
    
    func isExistingUser(withEmail email: String) -> AnyPublisher<Bool, AuthRepositoryError> {
        database.load(withEmail: email)
            .map { optionalUser in
                optionalUser?.email != nil
            }
            .mapError(AuthRepositoryError.storageError)
            .eraseToAnyPublisher()
    }
    
    var loggedInUserEmail: String? {
        keyValueLocalStorage.read(objectForKey: .userEmail)
    }
    
    func store(credentials: Credentials) -> Result<Void, AuthRepositoryError> {
        keyValueLocalStorage.set(credentials.email, for: .userEmail)
        
        return secureStorage.setValue(credentials.password, for: credentials.email)
            .mapError(AuthRepositoryError.storageError)
    }
    
    func storedPassword(for email: String) -> Result<String?, AuthRepositoryError> {
        secureStorage.getValue(for: email)
            .mapError(AuthRepositoryError.storageError)
    }
    
    func storeLoggedInUser(_ email: String) {
        keyValueLocalStorage.set(email, for: .userEmail)
    }
    
    func logout() {
        keyValueLocalStorage.delete(objectForKey: .userEmail)
    }
}
