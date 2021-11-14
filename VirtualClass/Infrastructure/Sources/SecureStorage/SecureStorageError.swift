//
//  SecureStorageError.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

public enum SecureStorageError: Error {
    case stringConversionError
    case dataConversionError
    case errorCreatingNewItem
    case unhandledQueryResult
    case errorUpdatingExistingItem
    case errorDeletingItem
    case unknownError(message: String)
}
