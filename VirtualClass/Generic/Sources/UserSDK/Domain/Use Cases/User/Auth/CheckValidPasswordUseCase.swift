//
//  CheckValidPasswordUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Foundation

protocol CheckValidPasswordUseCaseType {
    func isValid(password: String) -> Bool
}

final class CheckValidPasswordUseCase: CheckValidPasswordUseCaseType {
    func isValid(password: String) -> Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9@*#]{8,15})$")
        
        return passwordRegex.evaluate(with: password)
    }
}
