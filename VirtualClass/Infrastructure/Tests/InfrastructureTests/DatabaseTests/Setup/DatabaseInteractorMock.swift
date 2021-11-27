//
//  DatabaseInteractorMock.swift
//  
//
//  Created by Martin on 27.11.2021.
//

import protocol GRDB.DatabaseWriter

@testable import Database

final class DatabaseInteractorMock: DatabaseInteracting {
    var databaseConnection: DatabaseWriter?
    private let dbManager: SQLDBTesting
    private let setup: DatabaseSetup
    
    init(
        dbManager: SQLDBTesting,
        databaseSetup: DatabaseSetup
    ) {
        self.dbManager = dbManager
        self.setup = databaseSetup
        
        dbManager.databaseQueue(setup: setup) { result in
            switch result {
            case .success(let databaseConnection):
                self.databaseConnection = databaseConnection
            case .failure(let error):
                fatalError("Failed to initialize the database: \(error)")
            }
        }
    }
}
