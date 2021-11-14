//
//  LoginValidationResult.swift
//  
//
//  Created by Martin on 13.11.2021.
//

import Foundation

public enum LoginValidationResult {
    case invalidPassword
    case invalidEmail
    case invalidCredentials
    case validData
    case accountDoesNotExist
    case errorLoadingData
}
