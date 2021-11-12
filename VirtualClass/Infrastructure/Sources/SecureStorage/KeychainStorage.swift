//
//  File.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

public final class KeychainStorage {
    
    let secureStoreQueryable: SecureStorageQueryable
    
    public init(secureStoreQueryable: SecureStorageQueryable) {
      self.secureStoreQueryable = secureStoreQueryable
    }
}

extension KeychainStorage: SecureStorage {
    
    // updates password for specified account
    // if it cannot add / update password, it throws an error
    public func setValue(_ value: String, for userAccount: String) throws {
        // encode String into Data
        guard let password = value.data(using: .utf8) else {
            throw SecureStoreError.stringConversionError
        }
        
        // create a query and append the account to it
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount
        
        // return keychain item that matches the query
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        
        // check query result
        switch status {
            // if the result is success - password and account exists, you can replace the existing password
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = password
            
            status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            if status != errSecSuccess {
                throw error(from: status)
            }
            // if it cannot find the item, password for that account does not exists. Add the new item by invoking SecItemAdd
        case errSecItemNotFound:
            query[String(kSecValueData)] = password
            
            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw error(from: status)
            }
        default:
            throw error(from: status)
        }
    }
    
    // získá heslo pro specifický account, když se něco podělá, hází erorr
    public func getValue(for userAccount: String) throws -> String? {
        // keychain API pracuje Core Foundation (Obj-C) typy, proto je musíš mapovat do Swiftu a zpět
        
        // klíče jsou typu CFString -> ty je používáš jako klíče v dictionary a mapuješ je na String
        
        
        // vytváří query, postupně říkáš že:
        // zajímá tě jediná hodnota
        // zajímají tě všechny attributy danýho výsledku
        // zajímají tě odšifrovaný data
        // zajímá tě předaný account
        var query = secureStoreQueryable.query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = userAccount

        // provádí query, získává referency na hledaný item
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
          SecItemCopyMatching(query as CFDictionary, $0)
        }

        // kontroluje výsledek
        switch status {
        // pokud jsem item našel. Výsledek je dictionary obsahující všechny atributy, který jsi hledal
        // proto z něj vytáhnu Data a dekóduju je do Data
        case errSecSuccess:
          guard
            let queriedItem = queryResult as? [String: Any],
            let passwordData = queriedItem[String(kSecValueData)] as? Data,
            let password = String(data: passwordData, encoding: .utf8)
            else {
              throw SecureStoreError.dataConversionError
          }
          return password
        // pokud item nenajdu, vracím nil
        case errSecItemNotFound:
          return nil
        default:
          throw error(from: status)
        }
    }
    
    public func removeValue(for userAccount: String) throws {
        // vytvářím query
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount

        // provádím query / mažu heslo
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
          throw error(from: status)
        }
    }
    
    public func removeAllValues() throws {
        let query = secureStoreQueryable.query
          
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
          throw error(from: status)
        }

    }
    
    private func error(from status: OSStatus) -> SecureStoreError {
      let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
      return SecureStoreError.unhandledError(message: message)
    }
}
