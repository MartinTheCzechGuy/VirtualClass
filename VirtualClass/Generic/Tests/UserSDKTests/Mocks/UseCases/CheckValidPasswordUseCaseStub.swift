//
//  CheckValidPasswordUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

@testable import UserSDK

final class CheckValidPasswordUseCaseStub: CheckValidPasswordUseCaseType {
    private let result: Bool
    
    init(isValid: Bool) {
        self.result = isValid
    }
    
    func isValid(password: String) -> Bool {
        result
    }
}
