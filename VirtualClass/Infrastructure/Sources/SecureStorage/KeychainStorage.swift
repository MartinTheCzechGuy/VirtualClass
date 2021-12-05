//
//  KeychainStorage.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

public final class KeychainStorage {
    
    private let secureStoreQueryable: SecureStorageQueryable
    
    public init(secureStoreQueryable: SecureStorageQueryable) {
      self.secureStoreQueryable = secureStoreQueryable
    }
}

extension KeychainStorage: SecureStorage {
    public func setValue(_ value: String, for userAccount: String) -> Result<Void, SecureStorageError> {
        guard let password = value.data(using: .utf8) else {
            return .failure(.stringConversionError)
        }
        
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount
        
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = password
            
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            if status != errSecSuccess {
                return .failure(.errorUpdatingExistingItem)
            }            
        case errSecItemNotFound:
            query[String(kSecValueData)] = password
            
            status = SecItemAdd(query as CFDictionary, nil)
            
            if status != errSecSuccess {
                return .failure(.errorCreatingNewItem)
            }
            
        default:
            return .failure(.unhandledQueryResult)
        }
        
        return .success(())
    }
    
    public func getValue(for userAccount: String) -> Result<String?, SecureStorageError> {
        var query = secureStoreQueryable.query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = userAccount

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
          SecItemCopyMatching(query as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
          guard
            let queriedItem = queryResult as? [String: Any],
            let passwordData = queriedItem[String(kSecValueData)] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
            else {
                return .failure(.dataConversionError)
          }
            return .success(password)
        case errSecItemNotFound:
            return .success(nil)
        default:
            return .failure(.unhandledQueryResult)
        }
    }
    
    public func removeValue(for userAccount: String) -> Result<Void, SecureStorageError> {
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            return .failure(.errorDeletingItem)
        }
        
        return .success(())
    }
    
    public func removeAllValues() -> Result<Void, SecureStorageError> {
        let query = secureStoreQueryable.query
          
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            return .failure(.errorDeletingItem)
        }
        
        return .success(())
    }
}
