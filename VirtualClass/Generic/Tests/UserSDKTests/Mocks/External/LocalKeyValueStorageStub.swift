//
//  LocalKeyValueStorageStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import BasicLocalStorage

final class LocalKeyValueStorageStub: LocalKeyValueStorage {
    
    private let value: Any?
    
    private(set) var valueRead = false
    private(set) var valueSet = false
    private(set) var valueDeleted = false
    
    init(value: Any?) {
        self.value = value
    }
    
    func read<T>(objectForKey key: LocalKeyValueStorageKeys) -> T? {
        valueRead = true
        
        return value as? T
    }
    
    func set(_ value: Any?, for key: LocalKeyValueStorageKeys) {
        valueSet = true
    }
    
    func delete(objectForKey: LocalKeyValueStorageKeys) {
        valueDeleted = true
    }
    
    func clearStorage() {
        return
    }
}
