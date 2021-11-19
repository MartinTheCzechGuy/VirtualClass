//
//  UserDefaultsStorage.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

public protocol LocalKeyValueStorage {
    func read<T>(objectForKey key: LocalKeyValueStorageKeys) -> T?
    func set(_ value: Any?, for key: LocalKeyValueStorageKeys)
    func delete(objectForKey: LocalKeyValueStorageKeys)
    func clearStorage()
}

enum UserDefaultsStorageError: Error {
    case valueNotFound
}

final class UserDefaultsStorage {
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
}

extension UserDefaultsStorage: LocalKeyValueStorage {
    
    func set(_ value: Any?, for key: LocalKeyValueStorageKeys) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func read<T>(objectForKey key: LocalKeyValueStorageKeys) -> T? {
        guard let value = defaults.object(forKey: key.rawValue) as? T else {
            return nil
        }
        
        return value
    }
    
    func delete(objectForKey key: LocalKeyValueStorageKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
    
    func clearStorage() {
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
        }
    }
}
