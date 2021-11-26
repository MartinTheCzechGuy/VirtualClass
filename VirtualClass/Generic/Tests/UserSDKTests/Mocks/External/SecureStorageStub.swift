//
//  SecureStorageStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

import SecureStorage
@testable import UserSDK

final class SecureStorageStub: SecureStorage {
    
    struct ResultBundle {
        let getValueResult: Result<String?, SecureStorageError>
        let setValueResult: Result<Void, SecureStorageError>
        let removeValueResult: Result<Void, SecureStorageError>
        let removeAllValuesResult: Result<Void, SecureStorageError>
        
        static func mock(
            getValueResult: Result<String?, SecureStorageError> = .success(""),
            setValueResult: Result<Void, SecureStorageError> = .success(()),
            removeValueResult: Result<Void, SecureStorageError> = .success(()),
            removeAllValuesResult: Result<Void, SecureStorageError> = .success(())
        ) -> ResultBundle {
            .init(
                getValueResult: getValueResult,
                setValueResult: setValueResult,
                removeValueResult: removeValueResult,
                removeAllValuesResult: removeAllValuesResult
            )
        }
    }
    
    private let results: ResultBundle
    
    init(results: ResultBundle) {
        self.results = results
    }
    
    func getValue(for userAccount: String) -> Result<String?, SecureStorageError> {
        results.getValueResult
    }
    
    func setValue(_ value: String, for userAccount: String) -> Result<Void, SecureStorageError> {
        results.setValueResult
    }
    
    func removeValue(for userAccount: String) -> Result<Void, SecureStorageError> {
        results.removeValueResult
    }
    
    func removeAllValues() -> Result<Void, SecureStorageError> {
        results.removeAllValuesResult
    }
}
