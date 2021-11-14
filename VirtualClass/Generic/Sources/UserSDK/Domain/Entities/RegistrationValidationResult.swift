//
//  RegistrationValidationResult.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Foundation

public enum RegistrationValidationResult {
    case errorStoringCredentials
    case passwordsDontMatch
    case invalidPassword
    case invalidEmail
    case emailAlreadyUsed
    case validData
}
