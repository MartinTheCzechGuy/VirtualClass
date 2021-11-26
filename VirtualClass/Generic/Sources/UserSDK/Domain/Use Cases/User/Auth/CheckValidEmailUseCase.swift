//
//  CheckValidEmailUseCase.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Foundation

protocol CheckValidEmailUseCaseType {
    func isValid(email: String) -> Bool
}

final class CheckValidEmailUseCase {}

extension CheckValidEmailUseCase: CheckValidEmailUseCaseType {
    func isValid(email: String) -> Bool {
        let emailRegex = NSPredicate(format: "SELF MATCHES %@", "\\A[A-z0-9!#$%&'*+/=?^_‘{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_‘{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\z")
        
        return emailRegex.evaluate(with: email)
    }
}
