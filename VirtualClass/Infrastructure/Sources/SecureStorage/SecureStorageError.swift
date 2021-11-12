//
//  SecureStorageError.swift
//  
//
//  Created by Martin on 11.11.2021.
//

import Foundation

enum SecureStoreError: Error {
    case stringConversionError
    case dataConversionError
    case unhandledError(message: String)
}
