//
//  DatabaseInteracting.swift
//  
//
//  Created by Martin on 27.11.2021.
//

import GRDB

protocol DatabaseInteracting {
    var databaseConnection: DatabaseWriter? { get }
}

final class DatabaseInteractor: DatabaseInteracting {
    
    private(set) var databaseConnection: DatabaseWriter?
    private let dbManager: SQLDBManaging
    private let setup: DatabaseSetup
    
    init(
        dbManager: SQLDBManaging,
        databaseSetup: DatabaseSetup
    ) {
        self.dbManager = dbManager
        self.setup = databaseSetup
        
        dbManager.databasePool(setup: setup) { result in
            switch result {
            case .success(let databaseConnection):
                self.databaseConnection = databaseConnection
            case .failure(let error):
                fatalError("Failed to initialize the database: \(error)")
            }
        }
    }
}
