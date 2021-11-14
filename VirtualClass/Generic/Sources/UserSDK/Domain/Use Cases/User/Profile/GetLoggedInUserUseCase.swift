//
//  GetLoggedInUserUseCase.swift
//  
//
//  Created by Martin on 14.11.2021.
//

import Foundation
import BasicLocalStorage

protocol GetLoggedInUserUseCaseType {
    var email: String? { get }
}

final class GetLoggedInUserUseCase {
    private let userDefaults: LocalKeyValueStorage
    
    init(userDefaults: LocalKeyValueStorage) {
        self.userDefaults = userDefaults
    }
}

extension GetLoggedInUserUseCase: GetLoggedInUserUseCaseType {
    var email: String? {
        userDefaults.read(objectForKey: .userEmail)
    }
}
