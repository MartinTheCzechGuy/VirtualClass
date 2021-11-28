//
//  DatabaseManagerMock.swift
//  
//
//  Created by Martin on 27.11.2021.
//

import class GRDB.DatabasePool
import class GRDB.DatabaseQueue

@testable import Database

protocol SQLDBTesting: SQLDBManaging {
    func databaseQueue(setup: DatabaseSetup, completion: @escaping (Result<DatabaseQueue, DatabaseError>) -> Void)
}

final class DatabaseManagerMock: SQLDBTesting {
    func databasePool(setup: DatabaseSetup, completion: @escaping (Result<DatabasePool, DatabaseError>) -> Void) {
        fatalError("Should not be used in tests!")
    }
    
    func databaseQueue(setup: DatabaseSetup, completion: @escaping (Result<DatabaseQueue, DatabaseError>) -> Void) {
        do {
            let databaseQueue = DatabaseQueue()
            try setup.migrator.migrate(databaseQueue)
            
            completion(.success(databaseQueue))
        } catch {
            completion(.failure(DatabaseError(cause: .errorEstabilishingDBConnection, underlyingError: error)))
        }
    }
    
    func removeDatabase(completion: @escaping (Result<Void, DatabaseError>) -> Void) {
        fatalError("Should not be used in tests!")
    }
}
