//
//  CheckValidPasswordUseCaseStub.swift
//  
//
//  Created by Martin on 26.11.2021.
//

@testable import UserSDK

final class CheckValidEmailUseCaseStub: CheckValidEmailUseCaseType {
    
    private let result: Bool
    
    init(isValid: Bool) {
        self.result = isValid
    }
    
    func isValid(email: String) -> Bool {
        result
    }
}
