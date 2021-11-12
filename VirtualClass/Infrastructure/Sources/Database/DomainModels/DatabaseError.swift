//
//  DatabaseError.swift
//  
//
//  Created by Martin on 12.11.2021.
//

import Common
import Foundation

public struct DatabaseError: ErrorReportable {
    public enum ErrorCause: Error {
        case errorLoadingDataModel(modelName: String)
        case fetchError
        case objectNotFound
        case entitiesCollision
        case saveError
        case deleteError
        case observeError
    }
    
    init(cause: ErrorCause, underlyingError: Error?) {
        self.cause = cause
        self.underlyingError = underlyingError
    }
    
    public private(set) var cause: Error
    public private(set) var underlyingError: Error?
}
