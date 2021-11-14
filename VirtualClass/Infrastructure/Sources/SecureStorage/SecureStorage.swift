//
//  SecureStorage.swift
//  
//
//  Created by Martin on 11.11.2021.
//

public protocol SecureStorage {
    func getValue(for userAccount: String) -> Result<String?, SecureStorageError>
    func setValue(_ value: String, for userAccount: String) -> Result<Void, SecureStorageError>
    func removeValue(for userAccount: String) -> Result<Void, SecureStorageError>
    func removeAllValues() -> Result<Void, SecureStorageError>
}
