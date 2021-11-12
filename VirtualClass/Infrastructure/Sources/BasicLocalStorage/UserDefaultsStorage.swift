//
//  UserDefaultsStorage.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

protocol LocalKeyValueStorage {
    func read<T>(objectForKey key: String) -> T?
    func set(_ value: Any?, for key: String)
    func delete(objectForKey: String)
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
    
    func set(_ value: Any?, for key: String) {
        defaults.set(value, forKey: key)
    }
    
    func read<T>(objectForKey key: String) -> T? {
        guard let value = defaults.object(forKey: key) as? T else {
            return nil
        }
        
        return value
    }
    
    func delete(objectForKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    func clearStorage() {
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
        }
    }
}
