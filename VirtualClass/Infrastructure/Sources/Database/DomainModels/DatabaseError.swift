//
//  DatabaseError.swift
//
//
//  Created by Martin on 17.11.2021.
//

import Common

public struct DatabaseError: ErrorReportable {
    public enum ErrorCause: Error {
        case fetchError
        case objectNotFound
        case entitiesCollision
        case savingEntityError
        case loadingEntityError
        case deletingEntityError
        case updatingEntityError
        case observeError
        case invalidDBIdentifier
        case errorMovingDB
        case errorAccessingDBDirectory
        case errorEstabilishingDBConnection
        case errorDeletingDatabase
        case migrationError
        case objectConversionError
    }
    
    init(cause: ErrorCause, underlyingError: Error? = nil) {
        self.cause = cause
        self.underlyingError = underlyingError
    }
    
    public private(set) var cause: Error
    public private(set) var underlyingError: Error?
}
