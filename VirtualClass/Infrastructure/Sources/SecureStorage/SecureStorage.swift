//
//  SecureStorage.swift
//  
//
//  Created by Martin on 11.11.2021.
//

public protocol SecureStorage {
    /// Read value for specified account
    func getValue(for userAccount: String) -> Result<String?, SecureStorageError>
    /// Updates value for specified account.
    /// If it cannot add / update value, throws an error
    func setValue(_ value: String, for userAccount: String) -> Result<Void, SecureStorageError>
    func removeValue(for userAccount: String) -> Result<Void, SecureStorageError>
    func removeAllValues() -> Result<Void, SecureStorageError>
}
